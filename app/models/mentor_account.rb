class MentorAccount < Account
  default_scope { joins(:mentor_profile).includes(mentor_profile: :expertises) }

  scope :by_expertise_ids, ->(ids) {
    joins(mentor_profile: :guidance_profile_expertises)
    .where("guidance_profile_expertises.expertise_id IN (?)", ids)
    .uniq
  }

  delegate :school_company_name,
           :expertises,
           :expertise_names,
           :job_title,
    to: :mentor_profile,
    prefix: false
end
