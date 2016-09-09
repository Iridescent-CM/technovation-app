ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.include SigninHelper, type: :feature
  config.include ControllerSigninHelper, type: :controller
  config.include SelectDateHelper, type: :feature

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    Geocoder.configure(lookup: :test)

    Geocoder::Lookup::Test.add_stub(
      "Los Angeles, CA, United States", [{
        'latitude'     => 34.052363,
        'longitude'    => -118.256551,
        'address'      => 'Los Angeles, CA, USA',
        'state'        => 'California',
        'city'         => 'Los Angeles',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US',
      }]
    )

    Geocoder::Lookup::Test.add_stub(
      "Chicago, IL, United States", [{
        'latitude'     => 41.50196838,
        'longitude'    => -87.64051818,
        'address'      => 'Chicago, IL, USA',
        'state'        => 'Illinois',
        'city'         => 'Chicago',
        'state_code'   => 'IL',
        'country'      => 'United States',
        'country_code' => 'US',
      }]
    )

    Geocoder::Lookup::Test.add_stub(
      "60647", [{
        'latitude'     => 41.50196838,
        'longitude'    => -87.64051818,
        'address'      => 'Chicago, IL, USA',
        'state'        => 'Illinois',
        'city'         => 'Chicago',
        'state_code'   => 'IL',
        'country'      => 'United States',
        'country_code' => 'US',
      }]
    )

    Geocoder::Lookup::Test.add_stub(
      "Chicago, IL", [{
        'latitude'     => 41.50196838,
        'longitude'    => -87.64051818,
        'address'      => 'Chicago, IL, USA',
        'state'        => 'Illinois',
        'city'         => 'Chicago',
        'state_code'   => 'IL',
        'country'      => 'United States',
        'country_code' => 'US',
      }]
    )

    Geocoder::Lookup::Test.add_stub(
      [41.50196838, -87.64051818], [{
        'latitude'     => 41.50196838,
        'longitude'    => -87.64051818,
        'address'      => 'Chicago, IL, USA',
        'state'        => 'Illinois',
        'city'         => 'Chicago',
        'state_code'   => 'IL',
        'country'      => 'United States',
        'country_code' => 'US',
      }]
    )

    Geocoder::Lookup::Test.add_stub(
      [34.052363, -118.256551], [{
        'latitude'     => 41.50196838,
        'longitude'    => -87.64051818,
        'address'      => 'Chicago, IL, USA',
        'state'        => 'Illinois',
        'city'         => 'Chicago',
        'state_code'   => 'IL',
        'country'      => 'United States',
        'country_code' => 'US',
      }]
    )
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
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
