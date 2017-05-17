# Subscribers::Cat; cat = Cat.create name: 'asdf'; cat.update_attributes name: 'steve'

require "hearsay/engine"
require 'hearsay/config'
require 'hearsay/publisher'
require 'hearsay/subscriber'
require 'hearsay/event'
require 'hearsay/middleware'
require 'hearsay/version'
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
        yield Hearsay::Event.new(*args)
      end
    end
  end

  def self.scrub_payload!(hash, &blk)
    hash.each do |k, v|
      scrub_payload!(v, &blk)  if v.is_a?(Hash)
      hash[k] = v.inspect if blk.call(k, v)
    end
  end
end
