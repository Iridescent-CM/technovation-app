FactoryBot.define do
  factory :team_member_invite do
    inviter { FactoryBot.create(:student, :on_team) }
    association(:team) { inviter.team }
    sequence(:invitee_email) { |n| "invited-#{n}@factorygirl.com" }
  end

  factory :mentor_invite do
    inviter { FactoryBot.create(:student, :on_team) }
    association(:team) { inviter.team }
    sequence(:invitee_email) { |n| "invited-#{n}@factorygirl.com" }
  end
end
