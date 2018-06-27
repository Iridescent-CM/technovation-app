source 'https://rubygems.org'
ruby "~> 2"

gem 'rails', '~> 5.1'
gem 'puma', '~> 3.11'
gem 'pg', '~> 0.21'
gem 'casting', '~> 0.7'

gem 'fast_jsonapi', "~> 1.2"

gem 'textacular',
  git: 'https://github.com/Iridescent-CM/textacular.git',
  branch: 'change-assemble-query'

gem 'pdf-forms', '~> 1.1'

gem 'public_activity', "~> 1.5"
gem "paranoia", '~> 2.4'
gem 'counter_culture', '~> 1.11'

gem "autoprefixer-rails", "~> 6.7"
gem 'uglifier', '~> 3.2'
gem 'coffee-rails'

gem 'turbolinks', "~> 5.1"
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

gem 'simple_form',
  git: 'https://github.com/elsurudo/simple_form.git',
  branch: 'rails-5.1.0'
gem 'country_state_select',
  git: 'https://github.com/arvindvyas/Country-State-Select.git',
  branch: 'master'

gem 'nokogiri', "~> 1.8"

gem 'friendly_id', "~> 5.2"

gem 'has_secure_token', "~> 1.0"
gem 'bcrypt', '~> 3.1'

gem 'sidekiq', '~> 4.2'

gem 'createsend', '~> 4.1'

gem 'airbrake', '~> 6.3'
gem 'newrelic_rpm', '~> 3.18'

gem 'dalli', "~> 2.7"

gem 'geocoder', '~> 1.4'
gem 'timezone', '~> 1.2'

gem 'carrierwave',
  git: 'https://github.com/carrierwaveuploader/carrierwave.git',
  branch: :master

gem "mini_magick", "~> 4.8"
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
gem "oink", "~> 0.10"

gem 'loofah', '~> 2.2'

group :development, :test do
  gem 'rspec-rails', "~> 3.7"
  gem 'launchy', "~> 2.4"
  gem 'dotenv-rails', "~> 2.4"
end

group :development do
  gem 'pp_sql', "~> 0.2", require: false
  gem 'active_record_query_trace', "~> 1.5"
  gem "letter_opener", "~> 1.6"
  gem 'rack-mini-profiler', "~> 0.10"
  gem 'memory_profiler', "~> 0.9"
  gem 'listen', '~> 3.1'
  gem 'churn', "~> 1.0", require: false
end

group :test do
  gem 'timecop', "~> 0.9"
  gem 'vcr', "~> 3.0"
  gem 'webmock', "~> 3.4"
  gem 'sinatra', '~> 2.0'

  gem 'capybara-webkit',
    git: "https://github.com/thoughtbot/capybara-webkit.git",
    branch: :master

  gem 'database_cleaner', "~> 1.7"
  gem 'rails-controller-testing', "~> 1.0"
  gem "fakeredis", "~> 0.7", require: "fakeredis/rspec"

  # deprecated
  gem 'font-awesome-rails', "~> 4.7"
end

group :production, :development do
  gem 'premailer-rails', "~> 1.10"
end

group :production do
  gem 'hiredis', "~> 0.6"
  gem "rack-timeout", "~> 0.5"
  gem 'heroku-deflater',
    git: 'https://github.com/romanbsd/heroku-deflater.git',
    branch: 'master'
end

gem 'factory_bot_rails', "~> 4.10"

group :legacy do
  # LEGACY MIGRATION
  # Do not use these gems
  #
  gem 'flag_shih_tzu', "~> 0.3", require: false
  gem 'aws-sdk', "~> 2.11", require: false
end
