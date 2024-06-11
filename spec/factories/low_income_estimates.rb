FactoryBot.define do
  factory :low_income_estimate do
    sequence(:percentage) { |n| "FactoryBot Length #{n}" }
  end
end
