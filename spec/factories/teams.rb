FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| "Go Team Factory Girl #{n}!" }
    description { "Made with <3 by FactoryGirl" }
    division { Division.high_school }
  end

  factory :team_membership, class: "Membership" do
    association(:member) { FactoryGirl.create(:student) }
    association(:joinable) { FactoryGirl.create(:team) }
  end
end
