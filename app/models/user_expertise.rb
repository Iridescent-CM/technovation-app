class UserExpertise < ActiveRecord::Base
  belongs_to :user
  belongs_to :expertise, class_name: "ScoreCategory"
end
