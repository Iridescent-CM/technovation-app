FactoryGirl.define do
  factory :join_request do
    association(:requestor) { FactoryGirl.create(:mentor) }
    association(:joinable) { FactoryGirl.create(:team) }
  end
end
