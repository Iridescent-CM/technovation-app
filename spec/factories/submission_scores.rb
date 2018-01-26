FactoryBot.define do
  factory :submission_score, aliases: [:score] do
    judge_profile
    association(:team_submission, factory: [:team_submission, :junior])
    round SubmissionScore.rounds[:quarterfinals]

    trait :complete do
      completed_at Time.current
    end
  end
end
