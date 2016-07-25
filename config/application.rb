require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dap
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Poll monitored parameters for new data records this often:
    config.sensor_data_polling_interval = 3600 # seconds
    # Tag parameter as 'down' if no data received for this many seconds:
    config.sensor_data_alert_trigger = 7200 # seconds
    # Locate earliest measurements for timelines this often:
    config.timeline_earliest_measurement_polling_interval = 86400 # seconds
    # Prune duplicate measurements this often:
    config.duplicate_measurement_pruning_interval = 86400 # seconds
    # When pruning duplicate measurements, go back this many months (0 means current month only):
    config.pruning_retroactivity = 3
    config.redis_url = ENV['REDIS_URL'].present? ? ENV['REDIS_URL'] : 'redis://localhost:6379/12'
    config.redis_namespace = 'dap'
  end
end
