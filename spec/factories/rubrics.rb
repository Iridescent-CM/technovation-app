FactoryGirl.define do
  factory :rubric do
    competition 0
    identify_problem 0
    address_problem 0
    functional 0
    external_resources 0
    match_features 0
    interface 0
    description 0
    market 0
    revenue 0
    branding 0
    pitch 0
    team
    user { build(:user, :judge) }
  end
end
