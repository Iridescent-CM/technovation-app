require 'simplecov'

SimpleCov.start do
  add_filter '/config/'
  add_filter '/spec/'
  add_filter '.bundle/'
end

require 'paperclip/matchers'
require 'byebug'

RSpec.configure do |config|
  config.include Paperclip::Shoulda::Matchers
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.allow_message_expectations_on_nil = true
    mocks.verify_partial_doubles = true
  end
end
