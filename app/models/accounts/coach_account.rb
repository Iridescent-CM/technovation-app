class CoachAccount < Account
  default_scope { joins(:coach_profile).includes(coach_profile: :expertises) }

  has_one :coach_profile, foreign_key: :account_id
  accepts_nested_attributes_for :coach_profile
  validates_associated :coach_profile

  delegate :school_company_name,
           :expertises,
           :expertise_names,
           :job_title,
    to: :coach_profile,
    prefix: false
end
