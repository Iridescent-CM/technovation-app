FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| "Go Team Factory Girl #{n}!" }
    description { "Made with <3 by FactoryGirl" }
    division { Division.high_school }

    trait :with_mentor do
      after(:create) do |team, _|
        team.add_mentor(FactoryGirl.create(:mentor))
      end
    end

    transient do
      creator_in nil
      members_count 1
    end

    after(:create) do |team, evaluator|
      if !!evaluator.creator_in
        city, state, country = evaluator.creator_in.split(', ')

        evaluator.members_count.times do
          team.add_student(FactoryGirl.create(:student, city: city,
                                                        state_province: state,
                                                        country: country))
        end
      end
    end
  end

  factory :team_membership, class: "Membership" do
    association(:member) { FactoryGirl.create(:student) }
    association(:joinable) { FactoryGirl.create(:team) }
  end
end
