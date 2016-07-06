FactoryGirl.define do
  factory :expertise do
    sequence(:name) { |n| "Factory Expertise #{n}" }
  end
end
