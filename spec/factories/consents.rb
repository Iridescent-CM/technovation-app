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
end
