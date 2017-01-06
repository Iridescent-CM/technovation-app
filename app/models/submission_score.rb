class SubmissionScore < ActiveRecord::Base
  belongs_to :team_submission
  belongs_to :judge_profile
end
