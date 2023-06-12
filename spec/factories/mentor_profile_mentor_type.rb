FactoryBot.define do
  factory :mentor_profile_mentor_type do
    association :mentor_profile
    association :mentor_type
  end
end
