FactoryBot.define do
  factory :submission_score, aliases: [:score] do
    judge_profile
    association(:team_submission, factory: [:team_submission, :junior])
    round SubmissionScore.rounds[:quarterfinals]
    seasons [Season.current.year]

    trait :complete do
      completed_at Time.current
    end

    trait :brazil do
      association(:team_submission, factory: [:team_submission, :brazil])
    end

    trait :los_angeles do
      association(
        :team_submission,
        factory: [:team_submission, :los_angeles]
      )
    end

    trait :chicago do
      association(:team_submission, factory: [:team_submission, :chicago])
    end
  end
end
