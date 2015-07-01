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

  def create_judging_date_settings(anchor_date)
    # mostly arbitrary intervals
    dates = {
      qf_open: anchor_date,
      qf_close: anchor_date + 9.days,
      sf_open: anchor_date + 12.days,
      sf_close: anchor_date + 17.days,
      f_open: anchor_date + 22.days,
      f_close: anchor_date + 27.days,
    }

    Setting.create!(key:'quarterfinalJudgingOpen', value: dates[:qf_open])
    Setting.create!(key:'quarterfinalJudgingClose', value: dates[:qf_close])
    Setting.create!(key:'semifinalJudgingOpen', value: dates[:sf_open])
    Setting.create!(key:'semifinalJudgingClose', value: dates[:sf_close])
    Setting.create!(key:'finalJudgingOpen', value: dates[:f_open])
    Setting.create!(key:'finalJudgingClose', value: dates[:f_close])

    dates
  end
end
