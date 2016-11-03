FactoryGirl.define do
  factory :account do
    sequence(:email) { |n| "account#{n}@example.com" }
    password { "secret1234" }

    date_of_birth { Date.today - 31.years }
    first_name { "Factory" }
    last_name { "Account" }

    city "Chicago"
    state_province "IL"
    country "US"
    latitude 41.50196838
    longitude { -87.64051818 }
    geocoded { [city, state_province, Country[country].name].compact.join(', ') }

    season_ids { [Season.current.id] }

    after :create do |a|
      a.update_column(:profile_image, "foo/bar/baz.png")
    end
  end
end
