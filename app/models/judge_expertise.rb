class JudgeExpertise < ActiveRecord::Base
  belongs_to :authentication_role
  belongs_to :expertise, class_name: "ScoreCategory"
end
