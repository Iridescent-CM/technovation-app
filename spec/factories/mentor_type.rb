FactoryBot.define do
  factory :mentor_type do
    sequence(:name) { |n| "Factory Mentor Type #{n}" }
  end
end
