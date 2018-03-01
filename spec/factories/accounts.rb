FactoryBot.define do
  factory :account do
    sequence(:email) { |n| "account#{n}@example.com" }
    password { "secret1234" }
    email_confirmed_at { Time.current }

    date_of_birth { Date.today - 31.years }
    first_name { "Factory" }
    last_name { "Account" }

    city "Chicago"
    location_confirmed true

    trait :chicago do
      city "Chicago"
      state_province "IL"
      country "US"
    end

    trait :los_angeles do
      city "Los Angeles"
      state_province "CA"
      country "US"
    end

    trait :brazil do
      city "Salvador"
      state_province "Bahia"
      country "BR"
    end

    after :create do |a|
      RegisterToCurrentSeasonJob.perform_now(a)
      a.update_column(:profile_image, "foo/bar/baz.png")

      unless a.student_profile.present? or a.consent_signed?
        a.create_consent_waiver(FactoryBot.attributes_for(:consent_waiver))
      end

      unless a.background_check.present?
        a.create_background_check!(FactoryBot.attributes_for(:background_check))
      end
    end
  end
end
