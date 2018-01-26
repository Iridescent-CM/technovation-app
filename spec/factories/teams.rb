FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "FactoryBot #{n}!" }
    description { "Made with <3 by FactoryBot" }
    division { Division.senior }
    city "Chicago"
    state_province "IL"
    country "US"

    trait :junior do
      after(:create) do
        members = evaluator.members_count.times.collect {
          FactoryBot.create(:student, :junior)
        }

        TeamCreating.execute(team, members.first, FakeController.new)

        members.drop(1).each do |m|
          TeamRosterManaging.add(team, m)
        end
      end
    end

    trait :senior do
      after(:create) do
        members = evaluator.members_count.times.collect {
          FactoryBot.create(:student, :senior)
        }

        TeamCreating.execute(team, members.first, FakeController.new)

        members.drop(1).each do |m|
          TeamRosterManaging.add(team, m)
        end
      end
    end

    trait :with_mentor do
      after(:create) do |team, _|
        TeamRosterManaging.add(team, FactoryBot.create(:mentor))
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
        FactoryBot.create(:student)
      }

      TeamCreating.execute(team, members.first, FakeController.new)

      members.drop(1).each do |m|
        TeamRosterManaging.add(team, m)
      end
    end
  end

  factory :team_membership, class: "Membership" do
    association(:member) { FactoryBot.create(:student) }
    association(:team)
  end
end
