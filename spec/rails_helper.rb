ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

if Rails.env.production?
  abort("The Rails environment is running in production mode!")
end

require 'spec_helper'
require 'rspec/rails'
require 'capybara'

ActiveRecord::Migration.maintain_test_schema!

require 'vcr_helper'
require "geocoder_helper"

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

::Timezone::Lookup.config(:test)
::Timezone::Lookup.lookup.default("America/Los_Angeles")

Capybara.automatic_label_click = true

require 'rake'
Rails.application.load_tasks

RSpec.configure do |config|
  config.fail_fast = true

  config.include SigninHelper, type: :feature
  config.include SignupHelper, type: :feature

  config.include SigninHelper, type: :system
  config.include SignupHelper, type: :system

  config.include ControllerSigninHelper, type: :controller
  config.include ControllerSignupHelper, type: :controller

  config.include RequestSigninHelper, type: :request

  config.include SelectDateHelper, type: :feature
  config.include SelectDateHelper, type: :system

  config.include VueSelectInputHelper, type: :system

  config.include JudgingHelper
  config.include WebMock::API

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.use_transactional_fixtures = true

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end
end
