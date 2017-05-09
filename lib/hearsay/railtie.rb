require 'rails/railtie'

module Hearsay
  class Railtie < Rails::Railtie
    config.hearsay = ActiveSupport::OrderedOptions.new
    config.hearsay.enabled = false
    config.hearsay.enable_active_record = true

    initializer :hearsay do |app|
      if app.config.hearsay.enabled
        Railtie.initialize_active_record if app.config.hearsay.enable_active_record
      end
    end

    def self.initialize_active_record
      require 'hearsay/railties/active_record_extension'
      # Hearsay.subscribe!(/hearsay\.active_record/) do |event|
        # regex = Regexp.union Hearsay::Subscriber::ActiveRecord.subscribers_by_events.keys
        # if event.name.match(regex)
        #   Hearsay::Subscriber::ActiveRecord.subscribers_by_events[event.name].each do |subscriber|
        #     method_name = event.name.split('.').last
        #     subscriber.constantize.send(method_name, event) if subscriber.constantize.respond_to? method_name
        #   end
        # end
      # end
    end
  end
end
