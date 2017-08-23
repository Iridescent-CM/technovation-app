FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| "Go Team Factory Girl #{n}!" }
    description { "Made with <3 by FactoryGirl" }
    division { Division.senior }
    city "Chicago"
    state_province "IL"
    country "US"

    trait :with_mentor do
      after(:create) do |team, _|
        TeamRosterManaging.add(team, FactoryGirl.create(:mentor))
      end
    end

    trait :geocoded do
      after(:create) do |team, _|
        Geocoding.perform(team).with_save
      end
    end

    transient do
      members_count 1
    end

    after(:create) do |team, evaluator|
      members = evaluator.members_count.times.collect {
        FactoryGirl.create(:student)
      }
      team.student_ids = members.map(&:id)
      TeamCreating.execute(team, team.students.first)
    end
  end

  factory :team_membership, class: "Membership" do
    association(:member) { FactoryGirl.create(:student) }
    association(:joinable) { FactoryGirl.create(:team) }
  end
end
