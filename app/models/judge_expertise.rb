class JudgeExpertise < ActiveRecord::Base
  belongs_to :judge_profile
  belongs_to :expertise, class_name: "ScoreCategory"
end
