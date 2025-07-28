require_relative "boot"

require "rails/all"
require_relative '../app/middleware/redirector'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module Ezgo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.middleware.use Redirector
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # App timezone
    config.time_zone = 'Asia/Taipei'
    # App Locales
    config.i18n.available_locales = %i[zh-TW en]
    config.i18n.default_locale = :'zh-TW'
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_storage.content_types_to_serve_as_binary -= ['image/svg+xml']

    config.generators do |g|
      g.assets      false
      g.helper      false
      g.jbuilder    false
      g.stylesheets false
      g.test_framework :rspec,
        view_specs:       false,
        helper_specs:     false,
        routing_specs:    false,
        request_specs:    false,
        controller_specs: false
      g.decorator    false
    end
  end
end
