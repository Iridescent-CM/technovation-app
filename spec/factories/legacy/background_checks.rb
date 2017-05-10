FactoryGirl.define do
  factory :legacy_background_check, class: BackgroundCheck do
    account { FactoryGirl.create(:legacy_account) }
    sequence(:candidate_id) { |n| "FACTORY-C-#{n}" }
    sequence(:report_id) { |n| "FACTORY-R-#{n}" }
  end
end
