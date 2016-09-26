source 'https://rubygems.org'
ruby "2.3.1"

gem 'rails', '4.2.6'
gem 'puma', '~> 3.0'
gem 'pg', '~> 0.18'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem "autoprefixer-rails"

gem 'rails-i18n', '~> 4.0.0'

gem 'bcrypt', '~> 3.1.7'
gem 'sidekiq', '~> 4.1.1'
gem 'airbrake', '~> 5.2.1'
gem 'createsend', '~> 4.0.2'
gem 'newrelic_rpm', '~> 3.14.2.312'

gem 'sinatra'
gem "rack-timeout"
gem 'dalli'

gem 'geocoder', '~> 1.2.6'
gem 'carrierwave', '~> 0.11.2'
gem "mini_magick", "~> 4.5.1"
gem "fog", "~> 1.38.0"
gem 'carrierwave_direct'

gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'checkr-official', "~> 1.1.1", require: "checkr"

gem 'font-awesome-rails', '~> 4.6.3.1'
gem 'chosen-rails'
gem 'simple_form'
gem 'nested_form_fields'
gem 'countries', '~> 1.2.5', require: "countries/global"
gem 'country_state_select', '~> 3.0.2'

gem 'will_paginate', '~> 3.1.0'

gem 'indefinite_article'

gem 'timecop'

group :development, :test do
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'quiet_assets'
  gem 'rspec-rails'
  gem 'capybara-webkit'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem "refills"
  gem 'active_record_query_trace'
end

group :test do
  gem 'vcr'
  gem 'webmock'
end

group :qa, :staging, :production do
  gem 'rails_12factor'
  gem 'hiredis'
end

# LEGACY MIGRATION
# Do not use these gems
#
gem 'flag_shih_tzu'
gem 'paperclip'
gem 'aws-sdk'
