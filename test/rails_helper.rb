ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"
require 'database_cleaner'
require "minitest/pride"

Dir[Rails.root.join('test/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

class ActiveSupport::TestCase
  fixtures :all
end

DatabaseCleaner.strategy = :transaction

class Minitest::Test
  include SigninHelper
  include AttributesHelper
  include ScoringEnvironmentHelper

  def around(&block)
    DatabaseCleaner.start
    DatabaseCleaner.cleaning(&block)
  end
end
