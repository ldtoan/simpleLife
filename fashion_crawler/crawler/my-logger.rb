# coding: utf-8

require 'logger'

datetime_format = "%Y-%m-%d %H:%M:%S"

class MyLogger < Logger

  ERROR_LOG = File.expand_path(File.dirname(__FILE__)) + '/logs/error.log'

  def initialize(*args)
    @error_logger = Logger.new(ERROR_LOG, 'daily')
    @error_logger.formatter = Logger::Formatter.new
    # @error_logger.datetime_format = datetime_format

    super
  end

  def error(err)
    @error_logger.error(err)
    #erro_url = err.to_s.scan(/(www.\S+\/)/).join('').to_s.split('/').first
    #arr_url = Array.new
    super
  end

end

Log = MyLogger.new(STDOUT, 'daily')
Log.formatter = Logger::Formatter.new
Log.datetime_format = datetime_format
Log.level = Logger::INFO
