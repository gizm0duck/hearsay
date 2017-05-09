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
        require 'hearsay/railties/active_record_extension' if app.config.hearsay.enable_active_record
        Railtie.initialize_active_record if app.config.hearsay.enable_active_record
      end
    end

    def self.initialize_active_record
      puts "initializing active record"

      Hearsay.subscribe!(/hearsay\.active_record/) do |event|
        regex = Regexp.union Hearsay::Subscriber::ActiveRecord.subscribers_by_events.keys
        if event.name.match(regex)
          puts "MATCH!"
          Hearsay::Subscriber::ActiveRecord.subscribers_by_events[event.name].each do |subscriber|
            puts "SUBSCRIBER: #{subscriber}"
            subscriber.constantize.listen event
          end
        end
      end
    end

    def self.initialize_action_controller
      puts "initializing action controller"
      require 'hearsay/railties/active_record_extension'
      Hearsay.subscribe!(/hearsay\.action_controller/) do |event|
        regex = Regexp.union Hearsay::Subscriber::ActionController.subscribers_by_events.keys
        if event.name.match(regex)
          puts "MATCH!"
          Hearsay::Subscriber::ActionController.subscribers_by_events[event.name].each do |subscriber|
            puts "SUBSCRIBER: #{subscriber}"
            subscriber.constantize.listen event
          end
        end
      end
    end
  end
end
