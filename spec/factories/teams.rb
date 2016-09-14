FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| "Go Team Factory Girl #{n}!" }
    description { "Made with <3 by FactoryGirl" }
    division { Division.senior }

    trait :with_mentor do
      after(:create) do |team, _|
        team.add_mentor(FactoryGirl.create(:mentor))
      end
    end

    transient do
      creator_in "Chicago, IL, US"
      latitude 41.50196838
      longitude { -87.64051818 }
      members_count 1
    end

    after(:create) do |team, evaluator|
      evaluator.members_count.times do
        city, state, country = evaluator.creator_in.split(', ')
        team.add_student(FactoryGirl.create(:student, city: city,
                                                      state_province: state,
                                                      country: country,
                                                      latitude: evaluator.latitude,
                                                      longitude: evaluator.longitude))
      end
    end
  end

  factory :team_membership, class: "Membership" do
    association(:member) { FactoryGirl.create(:student) }
    association(:joinable) { FactoryGirl.create(:team) }
  end
end
