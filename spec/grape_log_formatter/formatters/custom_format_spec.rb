require 'spec_helper'

describe GrapeLogFormatter::Formatters::CustomFormat do
  describe '.call' do
    let(:severity) { :info }
    let(:datetime) { Time.now }
    let(:payload) do
      {
        custom: 'data',
        status: 200,
        method: 'GET',
        path: '/',
        controller: 'welcome',
        action: 'index',
        time: double('whatever').as_null_object
      }
    end
    subject { described_class.new.call(severity, datetime, nil, payload) }

    it 'include the datetime' do
      expect(subject).to include(datetime.strftime('%Y-%m-%d %H:%M:%S'))
    end

    it 'include the severity' do
      expect(subject).to include(severity.to_s)
    end

    it 'include the key value' do
      payload.each do |key, value|
        expect(subject).to include("#{key}=#{value}")
      end
    end
  end
end
