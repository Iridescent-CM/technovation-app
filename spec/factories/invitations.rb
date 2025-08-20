FactoryBot.define do
  factory :team_member_invite do
    inviter { FactoryBot.create(:student, :on_team) }
    team { association(:team) }
    sequence(:invitee_email) { |n| "invited-#{n}@factorygirl.com" }

    trait :pending do
      status { :pending }
    end

    trait :accepted do
      status { :accepted }
    end

    trait :declined do
      status { :declined }
    end
  end

  factory :mentor_invite do
    inviter { FactoryBot.create(:student, :on_team) }
    # association(:team) { inviter.team }
    # team { association :team, team_member_invites: [inviter] }
    team { association(:team) }
    sequence(:invitee_email) { |n| "invited-#{n}@factorygirl.com" }

    # trait :on_team do
    #   after(:create) do |invite|
    #     create(:team, team_member_invites: [invite])
    #   end
    # end

    trait :pending do
      status { :pending }
    end

    trait :accepted do
      status { :accepted }
    end

    trait :declined do
      status { :declined }
    end
  end
end
