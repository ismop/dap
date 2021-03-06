source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.2'

# Supported DB
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Visualization
gem 'haml-rails'
gem 'bootstrap-sass', '~>3.1'
gem 'font-awesome-rails'

# rendering documentation
gem 'redcarpet'
gem 'github-markup', require: 'github/markup'

# Faster JSON serializer
gem 'oj'

# ActiveRecord stuff
gem 'active_model_serializers', '0.10.0.rc3'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use debugger
# gem 'debugger', group: [:development, :test]

# User management
gem 'devise', '~>3.2'
gem 'cancancan'
gem 'role_model'
gem 'omniauth'

# RGeo is a geospatial data library for Ruby. It provides an implementation of OGC's Simple Features Specification,
# used by most standard spatial/geographic data storage systems such as PostGIS.
# A number of add-ons are also available to help with location-based applications such as Ruby On Rails.
gem 'rgeo'

# rgeo extensions for geoJSON API
gem 'rgeo-geojson'

# Activerecord-import is a library for bulk inserting data using ActiveRecord.
gem 'activerecord-import', '~> 0.6.0'

# The activerecord-postgis-adapter is the database adapter that will be using instead of the normal postgresql adapter.
gem 'activerecord-postgis-adapter', github: 'barelyknown/activerecord-postgis-adapter', branch: 'rails-4-1'

# Cross-Origin Resource Scharing for external UIs
gem 'rack-cors', :require => 'rack/cors'

# Date validation
gem 'date_validator'

# Geocoord converter
gem 'proj4rb'

# Influxdb for storage of measurement data
gem 'influxdb'

# Sidekiq async worker pool and clockwork scheduler for sensor data monitoring
gem 'sidekiq'
gem 'redis-namespace'
gem 'clockwork'

# Enumerize enables pretty enumerization of integer constants (e.g. in Parameter model)
gem 'enumerize'

group :development do
  # Avoid writing crap to logfiles in devmode
  gem 'quiet_assets'

  # Better error page
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  # pry console (replaces standard console; provides autocompletion etc.)
  gem 'pry-rails'

  # use thin for local setups
  gem 'thin'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-commands-rspec'

  gem 'guard-rspec', require: false
  # gem 'guard-spring'
end

group :test do
  gem 'minitest'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'factory_girl'

  # Used to generate lorems etc. in factories
  gem 'faker'

  # Used by rspec
  gem 'database_cleaner'
end

gem 'sentry-raven'

gem 'puma'
