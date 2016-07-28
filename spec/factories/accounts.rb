FactoryGirl.define do
  factory :account do
    sequence(:email) { |n| "account#{n}@example.com" }
    password { "secret1234" }
    password_confirmation { password }

    date_of_birth { Date.today - 31.years }
    first_name { "Factory" }
    last_name { "Account" }

    city { "Chicago" }
    state_province { "IL" }
    country { "US" }
    type { "Account" }
  end

  factory :student, parent: :account, class: 'StudentAccount' do
    type { "StudentAccount" }

    student_profile

    trait :on_team do
      after(:create) do |s|
        team = FactoryGirl.create(:team)
        FactoryGirl.create(:team_membership, member_type: "StudentAccount",
                                             member_id: s.id,
                                             joinable: team)
      end
    end
  end

  factory :mentor, parent: :account, class: 'MentorAccount' do
    type { "MentorAccount" }

    mentor_profile

    trait :with_expertises do
      after(:create) do |m|
        2.times do
          FactoryGirl.create(:expertise,
                             mentor_profile_ids: m.mentor_profile_id)
        end
      end
    end
  end

  factory :regional_ambassador, parent: :account, class: 'RegionalAmbassadorAccount' do
    type { "RegionalAmbassadorAccount" }

    regional_ambassador_profile

    trait :approved do
      after(:create) do |m|
        m.approved!
      end
    end
  end
end
