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
        {
          user_id: (user && user.id) || NONE,
          temp_user: temp_user,
          controller: resource,
          action: action,
        }
      end
    end
  end
end
