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
end