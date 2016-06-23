class JudgeScoringExpertise < ActiveRecord::Base
  belongs_to :judge_profile
  belongs_to :scoring_expertise, class_name: "ScoreCategory"
end
