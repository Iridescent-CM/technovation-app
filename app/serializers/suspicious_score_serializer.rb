class SuspiciousScoreSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :total, :total_possible, :judge_name

  attribute :submission_name do |score|
    score.team_submission.app_name
  end

  attribute :team_name do |score|
    score.team_submission.team_name
  end

  attribute :team_division do |score|
    score.team_submission.team_division_name
  end

  attribute :url do |score|
    Rails.application.routes.url_helpers.admin_score_path(score)
  end

  attribute :judge_url do |score|
    Rails.application.routes.url_helpers.admin_participant_path(score.judge_profile.account)
  end

  attribute :submission_url do |score|
    Rails.application.routes.url_helpers.admin_team_submission_path(score.team_submission)
  end
end