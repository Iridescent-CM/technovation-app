require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.

if ENV["USE_DOTENV"]
  require 'dotenv'
  Dotenv.load
end

Bundler.require(*Rails.groups)

module TechnovationApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.autoloader = :classic
    config.active_job.queue_adapter = ENV.fetch('ACTIVE_JOB_BACKEND') { :inline }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Pacific Time (US & Canada)'

    config.autoload_paths << Rails.root.join('app', 'models', '**/')
    config.autoload_paths << Rails.root.join("app/models/data_analyses")
    
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = [:en]
    config.i18n.available_locales = [:en, :'es-MX']

    config.generators do |g|
      g.test_framework false
      g.routes false
      g.assets false
      g.helper false
      g.factory_bot false
      g.factory_bot dir: 'spec/factories'
    end

    config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
      r301 '/users/sign_up', '/signup'
      r301 '/users/sign_in', '/signin'
    end

    config.middleware.use Rack::Deflater

    require "pdfkit"
    config.middleware.use PDFKit::Middleware,
      {header_right: '[page]/[toPage]'},
      :disposition => 'inline; filename="Technovation Parent Consent Form.pdf"',
      :only => %r[^/student/downloadable_parental_consent]

    config.active_record.schema_format = :sql
  end
end
