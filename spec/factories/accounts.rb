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
  end

  factory :mentor, parent: :account, class: 'MentorAccount' do
    mentor_profile

    trait :with_expertises do
      after(:create) do |m|
        2.times do
          FactoryGirl.create(:expertise,
                             guidance_profile_ids: m.mentor_profile_id)
        end
      end
    end
  end

  factory :student, parent: :account, class: 'StudentAccount' do
    student_profile
  end
end
