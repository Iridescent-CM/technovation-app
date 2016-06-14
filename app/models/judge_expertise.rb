class JudgeExpertise < ActiveRecord::Base
  belongs_to :judging_enabled_user_role
  belongs_to :expertise, class_name: "ScoreCategory"
end
