require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "hearsay"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.0.1
    config.autoload_paths << Rails.root.join('lib')

    config.hearsay.enabled = true
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

  end
end
