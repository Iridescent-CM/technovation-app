class CoachAccount < Account
  default_scope { joins(:coach_profile).includes(coach_profile: :expertises) }

  delegate :school_company_name,
           :expertises,
           :expertise_names,
           :job_title,
    to: :coach_profile,
    prefix: false
end
