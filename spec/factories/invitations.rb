FactoryBot.define do
  factory :team_member_invite do
    inviter { FactoryBot.create(:student, :on_team) }
    association(:team) { inviter.team }
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
    association(:team) { inviter.team }
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
end
