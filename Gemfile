source 'https://rubygems.org'
ruby "2.3.1"

gem 'rails', '~> 4.2.6'
gem 'puma', '~> 3.0'
gem 'pg', '~> 0.18'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'vanilla-ujs'

gem 'elasticsearch-model'
gem 'elasticsearch-rails'

gem 'friendly_id'

gem "autoprefixer-rails"
gem 'nokogiri'

gem 'rails-i18n', '~> 4.0.0'
gem 'obscenity', '~> 1.0.2'

gem 'has_secure_token'
gem 'bcrypt', '~> 3.1.7'
gem 'sidekiq', '~> 4.2.7'
gem 'airbrake', '~> 5.2.1'
gem 'createsend', '~> 4.0.2'
gem 'newrelic_rpm', '~> 3.14.2.312'

gem 'dalli'

gem 'geocoder', '~> 1.2.6'
gem 'timezone', '~> 1.0'

gem 'carrierwave', '~> 0.11.2'
gem "mini_magick", "~> 4.5.1"
gem "fog", "~> 1.38.0"
gem 'carrierwave_direct'

gem 'checkr-official', "~> 1.1.1", require: "checkr"

gem 'font-awesome-rails', '~> 4.6.3.1'
gem 'chosen-rails'
gem 'simple_form'
gem 'countries', '~> 1.2.5', require: "countries/global"
gem 'country_state_select', '~> 3.0.2'

gem "chartkick"
gem 'groupdate'

gem 'will_paginate', '~> 3.1.0'

gem 'indefinite_article'

gem 'rack-rewrite', '~> 1.5.0', require: 'rack/rewrite'

group :development, :test do
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'quiet_assets'
  gem 'rspec-rails'
  # gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'dotenv-rails'
end

group :development do
  gem 'active_record_query_trace'
  gem "letter_opener"
end

group :test do
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
  gem 'test_after_commit'
  gem 'sinatra'
end

group :qa, :staging, :production, :development do
  gem 'premailer-rails'
end

group :qa, :staging, :production do
  gem 'rails_12factor'
  gem 'hiredis'
  gem 'tunemygc'
  gem "rack-timeout"
end

group :qa, :test, :development do
  gem 'factory_girl_rails'
end

# LEGACY MIGRATION
# Do not use these gems
#
gem 'flag_shih_tzu'
gem 'paperclip'
gem 'aws-sdk'
