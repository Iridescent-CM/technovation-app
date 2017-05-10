source 'https://rubygems.org'
ruby "~> 2.4"

gem 'rails', '~> 5.1'
gem 'puma', '~> 3.8'
gem 'pg', '~> 0.20'

gem 'serviceworker-rails', '~> 0.5'

gem 'devise',
  git: 'https://github.com/plataformatec/devise.git',
  branch: 'master'

gem 'omniauth', '~> 1.6'

gem "paranoia", '~> 2.3'
gem 'counter_culture', '~> 1.0'

gem 'foundation-rails', '~> 6.3'
gem 'jquery-rails', '~> 4.3'
gem 'uglifier', '~> 3.2'
gem 'sass-rails', "~> 5.0"

gem 'elasticsearch-model', "~> 0.1"
gem 'elasticsearch-rails', "~> 0.1"
gem 'elasticsearch-dsl', "~> 0.1"

gem 'friendly_id', "~> 5.2"

gem 'rails-i18n', "~> 5.0"

gem 'has_secure_token', "~> 1.0"
gem 'bcrypt', '~> 3.1'
gem 'sidekiq', '~> 4.2'
gem 'airbrake', '~> 6.0'
gem 'createsend', '~> 4.1'
gem 'newrelic_rpm', '~> 3.18'

gem 'dalli', "~> 2.7"

gem 'geocoder', '~> 1.4'
gem 'timezone', '~> 1.2'

gem 'carrierwave',
  git: "https://github.com/carrierwaveuploader/carrierwave.git",
  branch: "master"

gem "mini_magick", "~> 4.7"
gem "fog", "~> 1.40"
gem 'carrierwave_direct', "~> 0.0"

gem 'checkr-official', "~> 1.2", require: "checkr"

gem 'font-awesome-rails', "~> 4.7"

gem 'countries', '~> 1.2', require: "countries/global"

gem 'country_state_select',
  git: 'https://github.com/arvindvyas/Country-State-Select.git',
  branch: 'master'

gem 'will_paginate', '~> 3.1'

gem 'rack-rewrite', '~> 1.5', require: 'rack/rewrite'

gem 'browser', "~> 2.3"
gem "oink", "~> 0.10"

group :development, :test do
  gem 'pry-rails', "~> 0.3"
  gem 'pry-nav', "~> 0.2"
  gem 'rspec-rails', "~> 3.5"
  gem 'dotenv-rails', "~> 2.2"
end

group :development do
  gem "letter_opener", "~> 1.4"
  gem 'rack-mini-profiler', "~> 0.10"
  gem 'memory_profiler', "~> 0.9"
  gem 'listen', '~> 3.1'
end

group :test do
  gem 'simplecov', require: false
  gem 'timecop', "~> 0.8"
  gem 'vcr', "~> 3.0"
  gem 'webmock', "~> 3.0"
  gem 'sinatra', '~> 2.0.0.beta'
  gem 'capybara-webkit', "~> 1.14"
  gem 'database_cleaner', "~> 1.5"
end

group :production, :development do
  gem 'premailer-rails', "~> 1.9"
end

group :production do
  gem 'hiredis', "~> 0.6"
  gem 'tunemygc', "~> 1.0"
  gem 'scout_apm', "~> 2.1"
  gem "rack-timeout", "~> 0.4"
end

group :test, :development do
  gem 'factory_girl_rails', "~> 4.8"
end

group :legacy1 do
  # LEGACY MIGRATION
  # Do not use these gems
  #
  gem 'flag_shih_tzu', "~> 0.3"
  gem 'paperclip', "~> 5.1"
  gem 'aws-sdk', "~> 2.9"
end
