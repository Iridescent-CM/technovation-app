class MentorAccount < Account
  default_scope { joins(:mentor_profile).includes(mentor_profile: :expertises) }

  after_initialize :build_mentor_profile, if: -> { mentor_profile.blank? }

  has_one :mentor_profile, foreign_key: :account_id, dependent: :destroy
  accepts_nested_attributes_for :mentor_profile
  validates_associated :mentor_profile

  scope :by_expertise_ids, ->(ids) {
    joins(mentor_profile: :guidance_profile_expertises)
    .where("guidance_profile_expertises.expertise_id IN (?)", ids)
    .uniq
  }

  delegate :expertises,
           :expertise_names,
           :job_title,
           :school_company_name,
    to: :mentor_profile,
    prefix: false

  delegate :id, to: :mentor_profile, prefix: true
end
