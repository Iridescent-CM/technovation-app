FactoryBot.define do
  factory :parental_consent do
    student_profile
    electronic_signature { "Parenty McGee" }

    trait :signed do
      status { :signed }
    end
  end

  factory :consent_waiver do
    account
    electronic_signature { "Accounty McGee" }
  end

  factory :media_consent do
    student_profile
    season { Season.current.year }

    trait :signed do
      electronic_signature { "Media McGiers" }
      signed_at { Time.current }
    end

    trait :unsigned do
      electronic_signature { nil }
      signed_at { nil }
    end
  end
end
