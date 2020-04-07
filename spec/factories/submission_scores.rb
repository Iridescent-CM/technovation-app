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

    trait :complete do
      completed_at { Time.current }
    end

    trait :incomplete do
      completed_at { nil }
    end

    trait :approved do
      approved_at { Time.current }
    end

    trait :senior do
      association(:team_submission, factory: [:team_submission, :complete, :senior])
    end

    trait :junior do
      association(:team_submission, factory: [:team_submission, :complete, :junior])
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
      ideation_1 { 1 }
      ideation_2 { 1 }
      ideation_3 { 1 }
      ideation_4 { 1 }
      technical_1 { 1 }
      technical_2 { 1 }
      technical_3 { 1 }
      technical_4 { 1 }
      pitch_1 { 1 }
      pitch_2 { 1 }
      entrepreneurship_1 { 1 }
      entrepreneurship_2 { 1 }
      entrepreneurship_3 { 1 }
      entrepreneurship_4 { 1 }
      overall_1 { 5 }
      overall_2 { 5 }
    end
  end
end
