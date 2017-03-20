source 'https://rubygems.org'
ruby "~> 2.3.1"

gem 'rails', '~> 4.2'
gem 'puma', '~> 3.7'
gem 'pg', '~> 0.19'
gem 'pg_search', '~> 2.0.1'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '~> 3.1'
gem 'jquery-rails', "~> 4.2"
gem 'vanilla-ujs', "~> 1.3"

gem 'clipboard-rails', "~> 1.6"

gem 'elasticsearch-model', "~> 0.1"
gem 'elasticsearch-rails', "~> 0.1"

gem 'friendly_id', "~> 5.2"

gem "autoprefixer-rails", "~> 6.7"
gem 'nokogiri', "~> 1.7"

gem 'rails-i18n', '~> 4.0'

gem 'has_secure_token', "~> 1.0"
gem 'bcrypt', '~> 3.1'
gem 'sidekiq', '~> 4.2'
gem 'airbrake', '~> 5.8'
gem 'createsend', '~> 4.1'
gem 'newrelic_rpm', '~> 3.18'

gem 'dalli', "~> 2.7"

gem 'geocoder', '~> 1.4'
gem 'timezone', '~> 1.2'

gem 'carrierwave', '~> 0.11'
gem "mini_magick", "~> 4.6"
gem "fog", "~> 1.38"
gem 'carrierwave_direct', "~> 0.0"

gem 'checkr-official', "~> 1.1", require: "checkr"

gem 'font-awesome-rails', '~> 4.7'
gem 'chosen-rails', "~> 1.5"
gem 'simple_form', "~> 3.4"
gem 'countries', '~> 1.2', require: "countries/global"
gem 'country_state_select', '~> 3.0'

gem "chartkick", "~> 2.2"
gem 'groupdate', "~> 3.2"

gem 'will_paginate', '~> 3.1'

gem 'indefinite_article', "~> 0.2"

gem 'rack-rewrite', '~> 1.5', require: 'rack/rewrite'

gem 'browser', "~> 2.3"
gem "oink", "~> 0.10"

group :development, :test do
  gem 'pry-rails', "~> 0.3"
  gem 'pry-nav', "~> 0.2"
  gem 'quiet_assets', "~> 1.1"
  gem 'rspec-rails', "~> 3.5"
  gem 'capybara-webkit', "~> 1.12"
  gem 'database_cleaner', "~> 1.5"
  gem 'launchy', "~> 2.4"
  gem 'dotenv-rails', "~> 2.2"
end

group :development do
  gem 'active_record_query_trace', "~> 1.5"
  gem "letter_opener", "~> 1.4"
end

group :test do
  gem 'timecop', "~> 0.8"
  gem 'vcr', "~> 3.0"
  gem 'webmock', "~> 2.3"
  gem 'test_after_commit', "~> 1.1"
  gem 'sinatra', "~> 1.4"
end

group :qa, :staging, :production, :development do
  gem 'premailer-rails', "~> 1.9"
end

group :qa, :staging, :production do
  gem 'rails_12factor', "~> 0.0"
  gem 'hiredis', "~> 0.6"
  gem 'tunemygc', "~> 1.0"
  gem "rack-timeout", "~> 0.4"
end

group :qa, :test, :development do
  gem 'factory_girl_rails', "~> 4.8"
end

group :legacy do
  # LEGACY MIGRATION
  # Do not use these gems
  #
  gem 'flag_shih_tzu', "~> 0.3"
  gem 'paperclip', "~> 5.1"
  gem 'aws-sdk', "~> 2.8"
end
