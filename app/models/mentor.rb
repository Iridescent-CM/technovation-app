class Mentor < Account
  default_scope { joins(:mentor_profile).includes(mentor_profile: :expertises) }

  scope :by_expertise_ids, ->(ids) {
    joins(mentor_profile: :expertises).where("expertises.id IN (?)", ids)
  }

  def expertise_names
    mentor_profile.expertises.collect(&:name)
  end
end
