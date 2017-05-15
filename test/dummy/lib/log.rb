require 'logging'

class Log
  attr_accessor :logger

  def initialize
    @logger = Logging.logger['example_logger']
    logger.level = :info


    logger.add_appenders Logging.appenders.file('log/hearsay.log', layout: Logging.layouts.pattern(pattern: '%m\n'))
  end

  def subscribe!
    Hearsay.subscribe! /hearsay/i do |event|
      puts "GOT EVENT"

      logger.info event.to_json
    end
  end
end
