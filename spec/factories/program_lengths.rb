FactoryBot.define do
  factory :program_length do
    sequence(:length) { |n| "FactoryBot Length #{n}" }
  end
end
