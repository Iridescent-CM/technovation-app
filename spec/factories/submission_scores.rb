FactoryGirl.define do
  factory :submission_score, aliases: [:score] do
    judge_profile
    team_submission
    round SubmissionScore.rounds[:quarterfinals]

    trait :complete do
      completed_at Time.current
    end
  end
end
