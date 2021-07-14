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
driver = :selenium_chrome_headless
Capybara.automatic_label_click = true
Capybara.default_max_wait_time = 10

Capybara.register_driver driver do |app|
  caps = ::Selenium::WebDriver::Remote::Capabilities.send("chrome")
  # This url is the local access url of the docker container
  # ::Selenium::WebDriver.for(:remote, url: "http://webdriver_chrome/wd/hub", desired_capabilities: caps)
  ::Selenium::WebDriver::Chrome::Service.driver_path = '/usr/bin/chromedriver'
  options = ::Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-gpu")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1200,1200")
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
Capybara.automatic_label_click = true
Capybara.default_max_wait_time = 100
Capybara.javascript_driver = driver
Capybara.server_port = ENV.fetch("CAPYBARA_SERVER_PORT", 31337)

require 'rake'

Rails.application.load_tasks

RSpec.configure do |config|
  config.fail_fast = ENV.fetch("RSPEC_FAIL_FAST", true)
  config.example_status_persistence_file_path = './tmp/spec/examples.txt'

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
  config.include MailgunHelper, type: :system
  config.include CoordinatesHelper, type: :system
  config.include AccountFormHelpers, type: :feature
  config.include AccountFormHelpers, type: :system
  config.include DatagridHelpers, type: :feature
  config.include DatagridHelpers, type: :system
  config.include JudgingHelper
  config.include WebMock::API
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.use_transactional_fixtures = true
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.after(:each) do
    Capybara.reset_sessions!
  end

  config.before(:each, type: :system, js: true) do
    driven_by driver
  end

  config.after(:each, js: :true) do |example|
    if example.exception
      save_and_open_screenshot if ENV.fetch("OPEN_SCREENSHOT_ON_FAILURE", false)
      save_and_open_page if ENV.fetch("OPEN_PAGE_ON_FAILURE", false)
      begin
        STDERR.puts page.driver.browser.manage.logs.get(:browser)
      rescue
        # not all drivers support browser logs, just keep quiet here
      end
    end
  end
end
