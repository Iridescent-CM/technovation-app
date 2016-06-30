class JudgeAccount < Account
  default_scope { joins(:judge_profile) }

  delegate :company_name,
           :job_title,
           :scoring_expertises,
           :scores,
           :scored_submission_ids,
           :admin?,
    to: :judge_profile,
    prefix: false
end
