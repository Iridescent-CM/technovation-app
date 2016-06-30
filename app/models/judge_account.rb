class JudgeAccount < Account
  default_scope { joins(:judge_profile) }

  delegate :company_name,
           :job_title,
           :scoring_expertises,
    to: :judge_profile,
    prefix: false
end
