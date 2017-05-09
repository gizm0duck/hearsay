# Subscribers::Cat; cat = Cat.create name: 'asdf'; cat.update_attributes name: 'steve'

require "hearsay/engine"
require 'hearsay/config'
require 'hearsay/subscriber'
require 'hearsay/railtie' if defined?(Rails)

module Hearsay
  def self.config
    @@config ||= Config.new
  end

  def self.configure
    yield self.config
  end

  def self.subscribe!(event_name=nil)
    if block_given?
      ActiveSupport::Notifications.subscribe(event_name) do |*args|
        yield ActiveSupport::Notifications::Event.new(*args)
      end
    end
  end
end
