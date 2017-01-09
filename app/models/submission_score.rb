class SubmissionScore < ActiveRecord::Base
  belongs_to :team_submission
  belongs_to :judge_profile

  validates :team_submission_id, uniqueness: { scope: :judge_profile_id }

  def complete?
    not attributes.values.any?(&:blank?)
  end

  def incomplete?
    not complete?
  end

  def team_submission_stated_goal
    team_submission.stated_goal || "No goal selected!"
  end

  def senior_team_division?
    team_submission.team.division.senior?
  end
end
