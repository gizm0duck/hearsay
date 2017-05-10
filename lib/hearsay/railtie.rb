require 'rails/railtie'

module Hearsay
  class Railtie < Rails::Railtie
    config.hearsay = ActiveSupport::OrderedOptions.new
    config.hearsay.enabled = false
    config.hearsay.enable_active_record = true
    config.hearsay.enable_action_controller = true

    initializer :hearsay do |app|
      if app.config.hearsay.enabled
        Railtie.initialize_active_record if app.config.hearsay.enable_active_record
        Railtie.initialize_action_controller if app.config.hearsay.enable_action_controller
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

    def self.initialize_action_controller
      puts "initializing action controller"
      require 'hearsay/railties/action_controller_extension'
    end
  end
end
