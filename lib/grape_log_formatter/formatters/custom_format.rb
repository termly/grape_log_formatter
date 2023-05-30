require 'grape_logging'

module GrapeLogFormatter
  module Formatters
    class CustomFormat < GrapeLogging::Formatters::Lograge
      def call(severity, datetime, _, data)
        lograge_format = super

        if defined?(Datadog::Tracing.log_correlation)
          dd_format = " #{Datadog::Tracing.log_correlation}"
        else
          dd_format = ""
        end

        headers_format = ""
        headers = request.headers
        # Outputting all headers
        headers.each do |key, value|
          headers_format = headers_format + "#{key}:#{value} "
        end

        "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} --#{dd_format} #{lograge_format} #{headers_format}"
      end
    end
  end
end
