require 'grape_logging'

module GrapeLogFormatter
  module Loggers
    class CustomLogging < GrapeLogging::Loggers::Base
      def parameters(request, response)
        sign_in_user = request.env['warden'].user
        temp_user = request.env['api.endpoint'].instance_variable_get(:@temp_user)
        user = sign_in_user || temp_user
        resource = request.env['api.endpoint'].instance_variable_get(:@options)[:for]
        action = request.env['api.endpoint'].instance_variable_get(:@options)[:path].first
        temp_user = user.nil? ? NONE : user.is_temp_user?
        standard_params = {
          user_id: (user && user.id) || NONE,
          temp_user: temp_user,
          controller: resource,
          action: action,
        }

        if request.env["additional_log_params"].instance_of?(Hash)
          standard_params.merge!(request.env["additional_log_params"])
        end
        standard_params
      end
    end
  end
end
