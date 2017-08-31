FactoryGirl.define do
  factory :join_request do
    association(:requestor, factory: :mentor)
    association(:team)
  end
end
