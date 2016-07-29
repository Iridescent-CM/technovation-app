class MentorAccount < Account
  default_scope { joins(:mentor_profile).includes(mentor_profile: :expertises) }

  has_one :mentor_profile, foreign_key: :account_id, dependent: :destroy
  accepts_nested_attributes_for :mentor_profile
  validates_associated :mentor_profile

  has_many :memberships, as: :member, dependent: :destroy

  has_many :join_requests, as: :requestor, dependent: :destroy

  scope :by_expertise_ids, ->(ids) {
    joins(mentor_profile: :mentor_profile_expertises)
    .where("mentor_profile_expertises.expertise_id IN (?)", ids)
    .uniq
  }

  delegate :expertises,
           :expertise_names,
           :job_title,
           :school_company_name,
           :background_check_complete?,
    to: :mentor_profile,
    prefix: false

  delegate :id, to: :mentor_profile, prefix: true

  def is_on_team?
    teams.any?
  end

  def teams
    Team.joins(:memberships).where('memberships.member_id = ?', id)
  end

  def requested_to_join?(team)
    join_requests.flat_map(&:joinable).include?(team)
  end

  def profile_complete?
    false
  end
end
