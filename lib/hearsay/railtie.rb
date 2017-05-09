require 'rails/railtie'

module Hearsay
  class Railtie < Rails::Railtie
    config.hearsay = ActiveSupport::OrderedOptions.new
    config.hearsay.enabled = false
    config.hearsay.enable_active_record = true
    config.hearsay.enable_action_controller = false

    initializer :hearsay do |app|
      if app.config.hearsay.enabled

        require 'hearsay/railties/action_controller_extension' if app.config.hearsay.enable_action_controller
        Railtie.initialize_active_record if app.config.hearsay.enable_active_record
      end
    end

    def self.initialize_active_record
      puts "initializing active record"
      require 'hearsay/railties/active_record_extension'
      Hearsay.subscribe!(/hearsay\.active_record/) do |event|
        regex = Regexp.union Hearsay::Subscriber::ActiveRecord.subscribers_by_events.keys
        if event.name.match(regex)
          Hearsay::Subscriber::ActiveRecord.subscribers_by_events[event.name].each do |subscriber|
            method_name = event.name.split('.').last
            subscriber.constantize.send(method_name, event) if subscriber.constantize.respond_to? method_name
          end
        end
      end
    end

    def self.initialize_action_controller
      require 'hearsay/railties/active_record_extension'
      Hearsay.subscribe!(/hearsay\.action_controller/) do |event|
        regex = Regexp.union Hearsay::Subscriber::ActionController.subscribers_by_events.keys
        if event.name.match(regex)
          Hearsay::Subscriber::ActionController.subscribers_by_events[event.name].each do |subscriber|
            subscriber.constantize.listen event
          end
        end
      end
    end
  end
end
