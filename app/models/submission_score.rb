class SubmissionScore < ActiveRecord::Base
  belongs_to :team_submission
  belongs_to :judge_profile

  scope :complete, -> { where("completed_at IS NOT NULL") }
  scope :incomplete, -> { where("completed_at IS NULL") }

  validates :team_submission_id, uniqueness: { scope: :judge_profile_id }

  delegate :app_name,
           :team_photo,
           :team_name,
    to: :team_submission,
    prefix: true,
    allow_nil: false

  def complete?
    not attributes.reject { |k, _| k == 'completed_at' }.values.any?(&:blank?)
  end

  def incomplete?
    not complete?
  end

  def complete!
    self.completed_at = Time.current
    save!
  end

  def team_submission_stated_goal
    team_submission.stated_goal || "No goal selected!"
  end

  def senior_team_division?
    team_submission.team.division.senior?
  end
end
