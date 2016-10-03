class JudgeAccount < Account
  default_scope { joins(:judge_profile) }

  has_one :background_check, foreign_key: :account_id, dependent: :destroy
  accepts_nested_attributes_for :background_check

  has_one :judge_profile, foreign_key: :account_id, dependent: :destroy
  accepts_nested_attributes_for :judge_profile
  validates_associated :judge_profile

  delegate :company_name,
           :job_title,
           :scoring_expertises,
           :scores,
           :scored_submission_ids,
    to: :judge_profile,
    prefix: false

  delegate :submitted?,
           :candidate_id,
           :report_id,
    to: :background_check,
    prefix: true,
    allow_nil: true

  def profile_id
    judge_profile.id
  end

  def complete_background_check!
    background_check.clear!
  end

  def background_check_complete?
    country != "US" or !!background_check && background_check.clear?
  end
end
