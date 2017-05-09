module Hearsay
  # TODO: review this class with respect to the railtie code; seems like a lot of redundancy between them (JN)
  class Config
    attr_accessor :key  # TODO: why is this named key?  How about app_id? (JN)
    attr_accessor :ignored_notification_names
    attr_accessor :ignored_database_actions
    attr_accessor :publish
    attr_accessor :publish_key

    # TODO: what do we do if the application does not configure a logger?  Do we blow up? (JN)
    attr_reader :logger
    def logger=(base_logger)
      @logger = Narratus::Logger.new(base_logger)
    end
  end
end
