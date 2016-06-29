class Mentor < Account
  default_scope { joins(:mentor_profile) }

  scope :by_expertise_ids, ->(ids) {
    joins(mentor_profile: :expertises).where("expertises.id IN (?)", ids)
  }
end
