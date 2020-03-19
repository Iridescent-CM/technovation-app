require 'bigdecimal'

RSpec.configure do |config|
  config.before(:suite) do
    Geocoder.configure(lookup: :test)

    Geocoder::Lookup::Test.add_stub("x", [])

    Geocoder::Lookup::Test.add_stub("stub-multiple", [
      {
        'latitude'     => 34.052363,
        'longitude'    => -118.256551,
        'address'      => 'Los Angeles, CA, USA',
        'state'        => 'California',
        'city'         => 'Los Angeles',
        'state_code'   => 'CA',
        'country'      => 'United States',
        'country_code' => 'US',
      },
      {
        'latitude'     => 43.0389,
        'longitude'    => 87.9065,
        'address'      => 'Milwaukee, WI, USA',
        'state'        => 'Wisconsin',
        'city'         => 'Milwaukee',
        'state_code'   => 'WI',
        'country'      => 'United States',
        'country_code' => 'US',
      }
    ])

    [
      "Los Angeles",
      "LA, CA, US",
      "Los Angeles, California, United States",
      "Los Angeles, United States",
      "Los Angeles, , US",
      "Los Angeles, , United States",
      "Los Angeles, CA",
      "Los Angeles, CA, US",
      "Los Angeles, CA, United States",
      "Los Angeles, California, US",
      [BigDecimal('34.052363'), BigDecimal('-118.256551')],
      [34.052363, -118.256551],
    ].each do |loc|
      Geocoder::Lookup::Test.add_stub(
        loc, [{
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
    end

    [
      "Milwaukee",
      "Milwaukee, WI",
      "Milwaukee, WI, United States",
      [43.0389, 87.9065]
    ].each do |loc|
      Geocoder::Lookup::Test.add_stub(
        loc, [{
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
    end

    ["Evanston", "Evanston, IL", "Evanston, IL, United States"].each do |loc|
      Geocoder::Lookup::Test.add_stub(
        loc, [{
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
    end

    [
      "IL, US",
      "Chicago, Illinois, US",
      "Chicago",
      "Chicago, Illinois, United States",
      "Chicago, IL",
      "Chicago, IL, United States",
      "Chicago, IL, US",
      "US",
      "United States",
      [BigDecimal('41.50196838'), BigDecimal('-87.64051818')],
      [41.50196838, -87.64051818],
      [41.501968, -87.640518],
    ].each do |loc|
      Geocoder::Lookup::Test.add_stub(
        loc, [{
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

    [
      "Dhurma",
      "Dhurma, Riyadh Province",
      "Dhurma, Riyadh Province, Saudi Arabia",
      "Dhurma, Riyadh Province, SA",
      "Dhurma, , Saudi Arabia",
      [24.6769697, 46.2431716],
    ].each do |loc|
      Geocoder::Lookup::Test.add_stub(
        loc, [{
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
    end

    [
      "Najran, Najran Province, SA",
      "Najran",
      "Najran, Najran Province, Saudi Arabia",
      "Najran, Najran Province",
      "Najran, , Saudi Arabia",
      [17.6004128, 44.2933307],
    ].each do |loc|
      Geocoder::Lookup::Test.add_stub(
        loc, [{
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

    ["Nablus, , PS", "Nablus, Palestine, State of", "Nablus, , Palestine, State of", [32.22111, 35.25444]].each do |loc|
      Geocoder::Lookup::Test.add_stub(
        loc, [{
          "latitude"     => 32.22111,
          "longitude"    =>  35.25444,
          'address'      => 'Nablus, State of Palestine',
          'state'        => '',
          'city'         => 'Nablus',
          'state_code'   => '',
          'country'      => 'Palestine, State of',
          'country_code' => 'PS',
        }]
      )
    end

    [
      "Salvador, BA, BR",
      "Salvador, BA, Brazil",
      "Salvador, Bahia, Brazil",
      "Salvador, Bahia, BR",
      [-12.7872335, -38.3067572]
    ].each do |loc|
      Geocoder::Lookup::Test.add_stub(
        loc, [{
          "latitude"     => -12.7872335,
          "longitude"    => -38.3067572,
          'address'      => 'Salvador, Bahia, Brazil',
          'state'        => 'Bahia',
          'city'         => 'Salvador',
          'state_code'   => 'BA',
          'country'      => 'Brazil',
          'country_code' => 'BR',
        }]
      )
    end

    [
      "Tel Aviv, IL-TA, IL",
      "Tel Aviv, Tel Aviv, IL",
      "Tel Aviv, Tel Aviv, Israel",
      "Tel Aviv, , Israel",
      [32.146611, 34.8519761]
    ].each do |loc|
      Geocoder::Lookup::Test.add_stub(
        loc, [{
          "latitude" => 32.146611,
          "longitude" => 34.8519761,
          "address" => "Tel Aviv, Tel Aviv, Israel",
          'state'        => 'Tel Aviv',
          'city'         => 'Tel Aviv',
          'state_code'   => 'IL-TA',
          'country'      => 'Israel',
          'country_code' => 'IL',
        }]
      )
    end
  end
end
