FactoryBot.define do
  factory :submission_score, aliases: [:score] do
    judge_profile
    association(:team_submission, factory: [:team_submission, :complete, :junior])
    round { :quarterfinals }
    seasons { [Season.current.year] }

    trait :past_season do
      after(:create) do |score, _evaluator|
        score.update(seasons: [Season.current.year - 1])
      end
    end

    trait :quarterfinals do
    end

    trait :semifinals do
      round { :semifinals }
    end

    trait :not_started do
      created_at { Time.current }
      updated_at { created_at }
      completed_at { nil }
    end

    trait :in_progress do
      updated_at { Time.current + 1.hour }
      completed_at { nil }
    end

    trait :complete do
      completed_at { Time.current }
    end

    trait :incomplete do
      completed_at { nil }
    end

    trait :approved do
      approved_at { Time.current }
    end

    trait :virtual do
      event_type { "virtual" }
    end

    trait :live do
      event_type { "live" }
    end

    trait :score_too_low do
      after :create do |score|
        score.update_columns(seems_too_low: true,
                             completed_too_fast: false,
                             completed_too_fast_repeat_offense: false,
                             approved_at: nil,
                             completed_at: Time.now)
      end
    end

    trait :score_completed_too_fast_by_repeat_offender do
      after :create do |score|
        score.update_columns(seems_too_low: false,
                             completed_too_fast: true,
                             completed_too_fast_repeat_offense: true,
                             approved_at: nil,
                             completed_at: Time.now)
      end
    end

    trait :score_too_low_and_completed_too_fast_by_repeat_offender do
      after :create do |score|
        score.update_columns(seems_too_low: true,
                             completed_too_fast: true,
                             completed_too_fast_repeat_offense: true,
                             approved_at: nil,
                             completed_at: Time.now)
      end
    end

    trait :senior do
      association(:team_submission, factory: [:team_submission, :complete, :senior])
    end

    trait :junior do
      association(:team_submission, factory: [:team_submission, :complete, :junior])
    end

    trait :beginner do
      association(:team_submission, factory: [:team_submission, :complete, :beginner])
    end

    trait :brazil do
      association(:team_submission, factory: [:team_submission, :complete, :brazil])
    end

    trait :los_angeles do
      association(
        :team_submission,
        factory: [:team_submission, :complete, :los_angeles]
      )
    end

    trait :chicago do
      association(:team_submission, factory: [:team_submission, :complete, :chicago])
    end

    trait :minimum_auto_approved_total do
      ideation_1 { 5 }
      ideation_2 { 5 }
      pitch_1 { 5 }
      pitch_2 { 5 }
      entrepreneurship_1 { 5 }
      entrepreneurship_2 { 5 }
    end
  end
end
