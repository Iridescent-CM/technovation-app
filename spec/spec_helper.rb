require "dotenv"
Dotenv.load

require "pry"
require "vcr_helper"

Dir[Dir.pwd + '/spec/no_rails_support/**/*.rb'].each { |f| require f }

include TestHelpers

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
