ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)

if Rails.env.production?
  abort("The Rails environment is running in production mode!")
end

require "spec_helper"
require "rspec/rails"
require "capybara"
require "vcr_helper"
require "geocoder_helper"
require "rake"

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

::Timezone::Lookup.config(:test)
::Timezone::Lookup.lookup.default("America/Los_Angeles")

Capybara.automatic_label_click = true
Capybara.default_max_wait_time = 5
Capybara.javascript_driver = ENV.fetch("JAVASCRIPT_DRIVER", "selenium_chrome_headless").to_sym
Capybara.server_port = ENV.fetch("CAPYBARA_SERVER_PORT", 31337)

WebMock.allow_net_connect!(net_http_connect_on_start: true)

Rails.application.load_tasks

RSpec.configure do |config|
  config.fail_fast = ENV.fetch("RSPEC_FAIL_FAST", true)
  config.example_status_persistence_file_path = "./tmp/spec/examples.txt"

  config.include SigninHelper, type: :feature
  config.include SignupHelper, type: :feature

  config.include SigninHelper, type: :system
  config.include SignupHelper, type: :system

  config.include ControllerSigninHelper, type: :controller

  config.include RequestSigninHelper, type: :request

  config.include SelectDateHelper, type: :feature
  config.include SelectDateHelper, type: :system

  config.include VueSelectInputHelper, type: :system

  config.include CoordinatesHelper, type: :system

  config.include AccountFormHelpers, type: :feature
  config.include AccountFormHelpers, type: :system

  config.include DatagridHelpers, type: :feature
  config.include DatagridHelpers, type: :system

  config.include JudgingHelper
  config.include WebMock::API
  config.include DataAnalyses, type: :feature

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.global_fixtures = :all

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!


  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.after(:each) do
    Capybara.reset_sessions!
  end

  config.before(:each, type: :system, js: true) do
    driven_by ENV.fetch("JAVASCRIPT_DRIVER", "selenium_chrome_headless").to_sym
  end

  config.before(:each, js: true) do
    Capybara.page.driver.browser.manage.window.resize_to(1200, 1200)
  end

  config.after(:each, js: true) do |example|
    if example.exception
      if ENV["OPEN_SCREENSHOT_ON_FAILURE"].to_s.downcase == "true"
        save_and_open_screenshot
      end

      if ENV["OPEN_PAGE_ON_FAILURE"].to_s.downcase == "true"
        save_and_open_page
      end

      begin
        STDERR.puts page.driver.browser.manage.logs.get(:browser)
      rescue
        # not all drivers support browser logs, just keep quiet here
      end
    end
  end
end
