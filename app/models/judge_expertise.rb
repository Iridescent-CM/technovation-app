class JudgeExpertise < ActiveRecord::Base
  belongs_to :user_role
  belongs_to :expertise, class_name: "ScoreCategory"
end
