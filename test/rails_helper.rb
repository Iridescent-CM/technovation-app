ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require 'database_cleaner'

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

require "minitest/pride"

Dir[Rails.root.join('test/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...
end

DatabaseCleaner.strategy = :transaction

class Minitest::Test
  include SigninHelper

  def around(&block)
    DatabaseCleaner.start
    DatabaseCleaner.cleaning(&block)
  end
end
