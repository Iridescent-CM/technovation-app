FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "FactoryBot #{n}!" }
    description { "Made with <3 by FactoryBot" }
    division { Division.none_assigned_yet }
    city { "Chicago" }
    state_province { "IL" }
    country { "US" }

    trait :submitted do
      association(:submission, :complete)
    end

    trait :live_event_eligible do
      team_submissions { build_list :submission, 1 }
    end

    trait :not_live_event_eligible do
      team_submissions { build_list :submission, 1 }
      events { build_list :event, 1 }
    end

    trait :los_angeles do
      city { "Los Angeles" }
      state_province { "CA" }
      country { "US" }
    end

    trait :chicago do
      city { "Chicago" }
      state_province { "IL" }
      country { "US" }
    end

    trait :brazil do
      city { "Salvador" }
      state_province { "Bahia" }
      country { "BR" }
    end

    trait :beginner do
      after(:create) do |team, evaluator|
        members = evaluator.members_count.times.collect {
          FactoryBot.create(:student, :beginner)
        }

        TeamCreating.execute(team, members.first, FakeController.new)

        members.drop(1).each do |m|
          TeamRosterManaging.add(team, m)
        end
      end
    end

    trait :junior do
      after(:create) do |team, evaluator|
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
      after(:create) do |team, evaluator|
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
        TeamRosterManaging.add(team, FactoryBot.create(:mentor, :onboarded))
      end
    end

    trait :geocoded do
      after(:create) do |team, _|
        Geocoding.perform(team).with_save
      end
    end

    transient do
      members_count { 1 }
    end

    after(:create) do |team, evaluator|
      members = evaluator.members_count.times.collect {
        FactoryBot.create(:student, :geocoded,
          city: team.city,
          state_province: team.state_province,
          country: team.country,
        )
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
