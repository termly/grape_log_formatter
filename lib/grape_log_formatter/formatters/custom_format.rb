require 'grape_logging'

module GrapeLogFormatter
  module Formatters
    class CustomFormat < GrapeLogging::Formatters::Lograge
      def call(severity, datetime, _, data)
        lograge_format = super

        if defined?(Datadog::Tracing.log_correlation)
          dd_format = " [#{Datadog::Tracing.log_correlation}]"
        else
          dd_format = ""
        end

        "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} -- #{lograge_format} #{dd_format}\n"
      end
    end
  end
end
