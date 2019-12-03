source 'https://rubygems.org'
ruby "~> 2"

gem 'rails', '~> 5.1.0'
# from GitHub security alert
gem "actionview", ">= 5.1.6.2"

gem 'puma', '~> 3.12'
gem 'pg', '~> 0.21'
gem 'casting', '~> 0.7'

gem 'barnes', '~> 0.0.7'

gem 'bootsnap', '~> 1.3', require: false

gem 'fast_jsonapi', "~> 1.4"
gem 'httparty', "~> 0.16"

# Patch applied: https://github.com/Iridescent-CM/textacular/commit/99cf5ef6cff0129b75bed261c6dd8e765f04a0c8
gem 'textacular',
  git: 'https://github.com/Iridescent-CM/textacular.git',
  branch: 'change-assemble-query'

gem 'pdf-forms', '~> 1.2'

gem 'public_activity', "~> 1.6"
gem "paranoia", '~> 2.4'
gem 'counter_culture', '~> 1.12'

gem "autoprefixer-rails", "~> 6.7"
gem 'uglifier', '~> 3.2'
gem 'coffee-rails', "~> 4.2"

gem 'turbolinks', "~> 5.2"
gem 'jquery-rails', "~> 4.3"
gem 'jquery-ui-rails', '~> 6.0'
gem 'lodash-rails', "~> 4.17"
gem 'dropzonejs-rails', "~> 0.8"
gem 'webpacker', '~> 3.5'

gem "cocoon", "~> 1.2"

gem 'sass-rails', "~> 5.0"
gem 'normalize-rails', "~> 4.1"

gem 'rails-i18n', "~> 5.1"
gem 'i18n-tasks', '~> 0.9'
gem 'clipboard-rails', "~> 1.7"
gem 'will_paginate', '~> 3.1'

gem 'datagrid', "~> 1.5"

gem 'simple_form', '~> 5.0'
gem 'country_state_select', '~> 3.0'

gem 'nokogiri', "~> 1.8"

gem 'friendly_id', "~> 5.2"

gem 'has_secure_token', "~> 1.0"
gem 'bcrypt', '~> 3.1'

gem 'sidekiq', '~> 4.2'

gem 'airbrake', '~> 6.3'
gem 'newrelic_rpm', '~> 3.18'
gem 'scout_apm', '~> 2.4'

gem 'dalli', "~> 2.7"

gem 'geocoder', '~> 1.4.9'
gem 'timezone', '~> 1.3'

gem 'carrierwave', "~> 1.2"
gem "mini_magick", "4.8.0"
gem "fog-aws", "~> 1.4"
gem 'carrierwave_direct', "~> 0.0"

gem 'checkr-official', "~> 1.5", require: "checkr"

gem 'countries', '~> 1.2', require: "countries/global"

gem 'city-state',
  git: 'https://github.com/Iridescent-CM/city-state.git',
  branch: 'keep-list-updated'

gem 'carmen', '~> 1.1'

gem 'indefinite_article', "~> 0.2"

gem 'rack-rewrite', '~> 1.5', require: 'rack/rewrite'

gem 'browser', "~> 2.5"

gem 'loofah', '~> 2.2'

group :development, :test do
  gem 'dotenv-rails', "~> 2.5"
end

group :development do
  gem 'pp_sql', "~> 0.2", require: false
  gem 'active_record_query_trace', "~> 1.5"
  gem "letter_opener", "~> 1.6"
  gem 'listen', '~> 3.1'
  gem 'churn', "~> 1.0", require: false
  gem 'web-console', '~> 3.7'
  gem 'spring', "~> 2.0"
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'mailgun-ruby', '~> 1.1'
end

group :test do
  gem 'timecop', "~> 0.9"
  gem 'vcr', "~> 3.0"
  gem 'webmock', "~> 3.5"
  gem 'sinatra', '~> 2.0'

  gem 'rails-controller-testing', "~> 1.0"
  gem "fakeredis", "~> 0.7", require: "fakeredis/rspec"

  gem 'capybara', '~> 2.18'
  gem 'webdrivers', '~> 4.0'
  gem 'rspec-rails', "~> 3.8"

  # deprecated
  gem 'font-awesome-rails', "~> 4.7"
end

group :production, :development do
  gem 'premailer-rails', "~> 1.10"
end

group :production do
  gem 'hiredis', "~> 0.6"
  gem "rack-timeout", "~> 0.5"
  gem 'heroku-deflater', "~> 0.6"
end

gem 'factory_bot_rails', "~> 4.11"

group :legacy do
  # LEGACY MIGRATION
  # Do not use these gems
  #
  gem 'flag_shih_tzu', "~> 0.3", require: false
  gem 'aws-sdk', "~> 2.11", require: false
end
