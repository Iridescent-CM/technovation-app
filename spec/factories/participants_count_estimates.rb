FactoryBot.define do
  factory :participant_count_estimate do
    sequence(:range) { |n| "FactoryBot Length #{n}" }
  end
end
