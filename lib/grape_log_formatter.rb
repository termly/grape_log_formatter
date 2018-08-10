require 'grape_log_formatter/version'
require 'grape_log_formatter/formatters/custom_format'
require 'grape_log_formatter/loggers/custom_logging'
require 'lograge'

Lograge.formatter = Lograge::Formatters::KeyValue.new
