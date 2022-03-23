require_relative "boot"


require "rails"
# Pick the frameworks you want:
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
require 'yaml'
require 'active_support'
require "active_support"; require "active_support/core_ext/object"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

SETTINGS = YAML.safe_load(File.read(File.expand_path('settings.yml', __dir__)))
SETTINGS.merge! SETTINGS.fetch(Rails.env, {})
SETTINGS.symbolize_keys!

module OhanaApi
  class Application < Rails::Application
    config.active_record.legacy_connection_handling = false

    config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')
    
    # config.eager_load_paths << Rails.root.join("extras")

    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.0

    # config.load_defaults 6.1
    config.load_defaults 7.0

    config.active_record.belongs_to_required_by_default = false

     # don't generate RSpec tests for views and helpers
     config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'

      g.view_specs false
      g.helper_specs false
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run 'rake -D time' for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.active_record.schema_format = :sql

    # CORS support
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource %r{/locations|organizations|search|lookahead|search_needs/*},
                 headers: :any,
                 methods: %i[get put patch post delete],
                 expose: ['Etag', 'Last-Modified', 'Link', 'X-Total-Count']
      end
    end

    # This is required to be able to pass in an empty array as a JSON parameter
    # when updating a Postgres array field. Otherwise, Rails will convert the
    # empty array to `nil`. Search for "deep munge" on the rails/rails GitHub
    # repo for more details.
    config.action_dispatch.perform_deep_munge = false

    config.action_controller.per_form_csrf_tokens = true

    config.active_record.time_zone_aware_types = [:datetime]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"

   
    config.active_support.default_message_encryptor_serializer = :marshall



    # config.eager_load_paths << "#{Rails.root}/extras"
    # config.eager_load_paths << "#{Rails.root}/lib"

    config.upload_server = if ENV["UPLOAD_SERVER"].present?
      ENV["UPLOAD_SERVER"].to_sym
    elsif Rails.env.production?
      :s3_multipart
    else
      :app
    end
  end

end
