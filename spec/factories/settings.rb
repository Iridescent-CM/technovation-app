FactoryGirl.define do
  factory :setting do
    key 'Any Key'
    value 'Any Value'

    trait :student_registration_open do
      key 'studentRegistrationOpen'
      value 'true'
    end

    trait :mentor_registration_open do
      key 'mentorRegistrationOpen'
      value 'true'
    end

    trait :coach_registration_open do
      key 'coachRegistrationOpen'
      value 'true'
    end

    trait :judge_registration_open do
      key 'judgeRegistrationOpen'
      value 'true'
    end
  end
end
