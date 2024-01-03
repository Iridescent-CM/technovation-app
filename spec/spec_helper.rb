require "dotenv"
Dotenv.load

require "vcr_helper"
require "capybara/email/rspec"
require "rspec/retry"
require "pundit/rspec"

Dir[Dir.pwd + "/spec/no_rails_support/**/*.rb"].each { |f| require f }

include TestHelpers

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions =
      true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.verbose_retry = true
  config.default_retry_count = 2
  config.exceptions_to_retry = [Net::ReadTimeout]
end

RSpec::Matchers.define_negated_matcher :not_change, :change
