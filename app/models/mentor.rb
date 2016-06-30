class Mentor < Account
  default_scope { joins(:mentor_profile).includes(mentor_profile: :expertises) }

  scope :by_expertise_ids, ->(ids) {
    joins(mentor_profile: :guidance_profile_expertises)
    .where("guidance_profile_expertises.expertise_id IN (?)", ids)
    .uniq
  }

  def expertise_names
    mentor_profile.expertises.collect(&:name)
  end
end
