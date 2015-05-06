ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def setup
    default_response = {
      status: 200,
      body: '',
      headers: {}
    }
    maps_response = '{"results":[],"status":"OK"}'

    stub_request(:get, /.*maps.googleapis.com.*/).
      to_return(default_response.merge(body: maps_response))
    stub_request(:post, /.*api.createsend.com.*/).
      to_return(default_response)
  end
end
