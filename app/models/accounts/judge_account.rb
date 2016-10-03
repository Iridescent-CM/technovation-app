class JudgeAccount < Account
  default_scope { joins(:judge_profile) }

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

  def profile_id
    judge_profile.id
  end
end
