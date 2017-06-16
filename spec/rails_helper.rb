ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!

require 'vcr_helper'

require "geocoder_helper"

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

::Timezone::Lookup.config(:test)
::Timezone::Lookup.lookup.default("America/Los_Angeles")

Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.fail_fast = true

  config.include SigninHelper, type: :feature
  config.include SignupHelper, type: :feature
  config.include ControllerSigninHelper, type: :controller
  config.include ControllerSignupHelper, type: :controller
  config.include SelectDateHelper, type: :feature
  config.include JudgingHelper
  config.include WebMock::API

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do |example|
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do |example|
    unless example.metadata[:no_es_stub]
      stub_request(:any, /localhost:9200/).to_rack(FakeBonsai)
    end
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
