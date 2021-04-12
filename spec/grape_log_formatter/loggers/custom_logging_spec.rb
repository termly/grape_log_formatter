require 'spec_helper'
require 'ostruct'

NONE = 'NONE'.freeze

describe GrapeLogFormatter::Loggers::CustomLogging do
  class DummyClass
    def initialize(temp_user, options)
      @temp_user = temp_user
      @options = options
    end

    attr_reader :user
  end

  describe '#parameters' do
    subject { described_class.new.parameters(mock_request, mock_response) }
    let(:user) { double('user-object', id: 1, is_temp_user?: false) }
    let(:temp_user) { double('temp-user-object', id: 2, is_temp_user?: true) }
    let(:options) do
      {
        for: 'UsersApi',
        path: ['current_user']
      }
    end

    let(:mock_request) do
      OpenStruct.new(env: {
        'api.endpoint' => DummyClass.new(temp_user, options),
        'warden' => double('warden-object', user: nil)
      })
    end

    let(:mock_response) do
      OpenStruct.new(status: 200, body: '')
    end

    it 'set controller from the resource option' do
      expect(subject[:controller]).to eql options[:for]
    end

    it 'set action from the resource option' do
      expect(subject[:action]).to eql options[:path].first
    end

    context 'user is temp user' do
      let(:mock_request) do
        OpenStruct.new(env: {
          'api.endpoint' => DummyClass.new(temp_user, options),
          'warden' => double('warden-object', user: nil)
        })
      end
      it 'set user from api endpoint' do
        expect(subject[:user_id]).to eql temp_user.id
      end

      it 'set temp user true' do
        expect(subject[:temp_user]).to eql true
      end
    end

    context 'user is signin user ' do
      let(:mock_request) do
        OpenStruct.new(env: {
          'api.endpoint' => DummyClass.new(nil, options),
          'warden' => double('warden-object', user: user)
        })
      end

      it 'set user from warden' do
        expect(subject[:user_id]).to eql user.id
      end

      it 'set temp_user false' do
        expect(subject[:temp_user]).to eql false
      end
    end

    context 'response is success' do
      it 'did not set error key' do
        expect(subject[:error]).to eql nil
      end
    end

    xcontext 'response is error' do
      let(:error_message) { 'error message here' }
      context 'is RackProxyBody' do
        let(:mock_response) do
          OpenStruct.new(status: 400, body: error_message)
        end

        it 'set from the response body' do
          expect(subject[:error]).to eql error_message
        end
      end

      context 'is pure string' do
        let(:mock_response) { error_message }
        it 'set errror from response' do
          expect(subject[:error]).to eql error_message
        end
      end
    end
  end
end
