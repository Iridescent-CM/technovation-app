class ScoreSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :total, :total_possible

  attribute :submission_name do |score|
    score.team_submission.app_name
  end

  attribute :team_name do |score|
    score.team_submission.team_name
  end

  attribute :team_division do |score|
    score.team_submission.team_division_name
  end

  attribute :event_type do |score|
    score.event_type
  end

  attribute :url do |score|
    Rails.application.routes.url_helpers.new_judge_score_path(score_id: score.id)
  end

  attribute :submission_url do |score|
    Rails.application.routes.url_helpers.project_path(score.team_submission)
  end
end
