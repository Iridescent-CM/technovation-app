FactoryBot.define do
  factory :submission_score, aliases: [:score] do
    judge_profile
    association(:team_submission, factory: [:team_submission, :complete, :junior])
    round :quarterfinals
    seasons [Season.current.year]

    trait :past_season do
      after(:create) do |score, _evaluator|
        score.update(seasons: [Season.current.year - 1])
      end
    end

    trait :quarterfinals do
    end

    trait :semifinals do
      round :semifinals
    end

    trait :complete do
      completed_at Time.current
    end

    trait :incomplete do
      completed_at nil
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

    trait :minimum_total do
      sdg_alignment 5
      evidence_of_problem 5
      problem_addressed 5
      app_functional 5
      business_plan_short_term 5
    end
  end
end
