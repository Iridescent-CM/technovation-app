FactoryGirl.define do
  factory :parental_consent do
    student
    electronic_signature "Parenty McGee"
    consent_confirmation 1
  end
end
