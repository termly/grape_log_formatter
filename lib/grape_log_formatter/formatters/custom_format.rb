module GrapeLogFormatter
  module Formatters
    class CustomFormat < GrapeLogging::Formatters::Lograge
      def call(severity, datetime, _, data)
        lograge_format = super

        "[#{datetime.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} -- #{lograge_format}\n"
      end
    end
  end
end
