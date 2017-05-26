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
        Railtie.initialize_action_cable if app.config.hearsay.enable_action_cable
      end

      app.config.middleware.insert_before Rails::Rack::Logger, Hearsay::Middleware
    end

    def self.initialize_active_record
      require 'hearsay/railties/active_record_extension'
    end

    def self.initialize_action_controller
      require 'hearsay/railties/action_controller_extension'
    end

    def self.initialize_action_cable
      require 'hearsay/railties/action_cable_extension'
    end
  end
end
