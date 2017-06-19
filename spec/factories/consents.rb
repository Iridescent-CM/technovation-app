FactoryGirl.define do
  factory :parental_consent do
    student_profile
    electronic_signature "Parenty McGee"
  end

  factory :consent_waiver do
    account
    electronic_signature "Accounty McGee"
  end
end
