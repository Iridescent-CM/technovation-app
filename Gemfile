ruby '2.1.5'

source 'https://rubygems.org'

# core rails gems
gem 'rails', '~> 4.1.15'
gem 'pg'

# core compiler / language gems
gem 'coffee-script'
gem 'coffee-rails', '~> 4.0.0'
gem 'slim-rails'
gem 'redcarpet'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'puma_worker_killer'

# view / templating gems / front-end gems
gem 'autoprefixer-rails'
gem 'bootstrap-sass', :git => 'git://github.com/twbs/bootstrap-sass.git'
gem 'bootstrap_form'
gem 'select2-rails'
gem 'countries'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks'
gem 'kaminari'

# rails functionality extensions
gem 'activeadmin', github: 'activeadmin'
gem 'devise', github: 'plataformatec/devise'
gem 'geocoder'
gem 'flag_shih_tzu'
gem 'friendly_id', '~> 5.0'
gem 'has_scope'
gem 'paperclip'
gem 'pundit', github: 'elabs/pundit'
gem 'wicked', '~> 1.1'
gem 'createsend'
gem 'prawn'
gem 'prawn-templates'
gem 'cancan'

# general libraries
gem 'aws-sdk'
gem 'bcrypt', '~> 3.1.7'
gem 'jbuilder', '~> 2.0'
gem 'typhoeus'
gem 'airbrake', '~> 5.2.0'
gem 'newrelic_rpm'
gem 'puma' 

group :doc do
  gem 'sdoc', '~> 0.4.0'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'byebug'
  gem 'capybara'
  gem 'site_prism'
  gem 'faker'
end

group :development do
  gem 'seedbank'
  gem 'spring'
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'timecop'
  gem 'webmock'
  gem 'shoulda-callback-matchers'
  gem 'database_cleaner'
end

group :production, :staging, :qa do
  gem 'rails_12factor'
  gem 'rack-timeout'
end
