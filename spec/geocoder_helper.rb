RSpec.configure do |config|
  config.before(:suite) do
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
      "Milwaukee, WI", [{
        'latitude'     => 43.0389,
        'longitude'    => 87.9065,
        'address'      => 'Milwaukee, WI, USA',
        'state'        => 'Wisconsin',
        'city'         => 'Milwaukee',
        'state_code'   => 'WI',
        'country'      => 'United States',
        'country_code' => 'US',
      }]
    )

    Geocoder::Lookup::Test.add_stub(
      "Los Angeles, CA", [{
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
      "Evanston, IL", [{
        'latitude'     => 41.50196838,
        'longitude'    => -87.64051818,
        'address'      => 'Evanston, IL, USA',
        'state'        => 'Illinois',
        'city'         => 'Evanston',
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
      [43.0389, 87.9065], [{
        'latitude'     => 43.0389,
        'longitude'    => 87.9065,
        'address'      => 'Milwaukee, WI, USA',
        'state'        => 'Wisconsin',
        'city'         => 'Milwaukee',
        'state_code'   => 'WI',
        'country'      => 'United States',
        'country_code' => 'US',
      }]
    )

    Geocoder::Lookup::Test.add_stub(
      [34.052363, -118.256551], [{
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
      [24.6769697, 46.2431716], [{
        'latitude'     => 24.6769697,
        'longitude'    =>  46.2431716,
        'address'      => 'Dhurma, Riyadh Province, SA',
        'state'        => 'Riyadh Province',
        'city'         => 'Dhurma',
        'state_code'   => 'Riyadh Province',
        'country'      => 'Saudi Arabia',
        'country_code' => 'SA',
      }]
    )

    Geocoder::Lookup::Test.add_stub(
      "Dhurma", [{
        'latitude'     => 24.6769697,
        'longitude'    =>  46.2431716,
        'address'      => 'Dhurma, Riyadh Province, SA',
        'state'        => 'Riyadh Province',
        'city'         => 'Dhurma',
        'state_code'   => 'Riyadh Province',
        'country'      => 'Saudi Arabia',
        'country_code' => 'SA',
      }]
    )

    Geocoder::Lookup::Test.add_stub(
      [17.6004128, 44.2933307], [{
        'latitude'     => 17.6004128,
        'longitude'    => 44.2933307,
        'address'      => 'Najran, Najran Province, SA',
        'state'        => 'Najran Province',
        'city'         => 'Najran',
        'state_code'   => 'Najran Province',
        'country'      => 'Saudi Arabia',
        'country_code' => 'SA',
      }]
    )

    Geocoder::Lookup::Test.add_stub(
      "Najran", [{
        'latitude'     => 17.6004128,
        'longitude'    => 44.2933307,
        'address'      => 'Najran, Najran Province, SA',
        'state'        => 'Najran Province',
        'city'         => 'Najran',
        'state_code'   => 'Najran Province',
        'country'      => 'Saudi Arabia',
        'country_code' => 'SA',
      }]
    )
  end
end
