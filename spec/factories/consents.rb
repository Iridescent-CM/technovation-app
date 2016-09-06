FactoryGirl.define do
  factory :parental_consent do
    student
    electronic_signature "Parenty McGee"
  end

  factory :consent_waiver do
    account
    electronic_signature "Accounty McGee"
    consent_confirmation 1
  end
end
