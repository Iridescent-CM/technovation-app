class MentorAccount < Account
  default_scope { joins(:mentor_profile).includes(mentor_profile: :expertises) }

  has_one :mentor_profile, foreign_key: :account_id, dependent: :destroy
  accepts_nested_attributes_for :mentor_profile
  validates_associated :mentor_profile

  has_many :memberships, as: :member, dependent: :destroy

  has_many :join_requests, as: :requestor, dependent: :destroy
  has_many :mentor_invites, foreign_key: :invitee_id
  has_many :team_member_invites, foreign_key: :inviter_id

  scope :by_expertise_ids, ->(ids) {
    joins(mentor_profile: :mentor_profile_expertises)
    .where("mentor_profile_expertises.expertise_id IN (?)", ids)
    .uniq
  }

  scope :searchable, -> { where("mentor_profiles.searchable = ?", true) }

  delegate :expertises,
           :expertise_names,
           :job_title,
           :school_company_name,
           :background_check_complete?,
           :bio,
           :enable_searchability,
           :background_check_candidate_id,
           :background_check_report_id,
           :complete_background_check!,
    to: :mentor_profile,
    prefix: false

  delegate :id, to: :mentor_profile, prefix: true

  def pending_team_invitations
    mentor_invites.pending
  end

  def pending_team_requests
    join_requests.pending
  end

  def is_on_team?
    teams.current.any?
  end

  def teams
    @teams ||= Team.joins(:memberships).where('memberships.member_id = ?', id)
  end

  def team_ids
    teams.current.collect(&:id)
  end

  def can_join_a_team?
    true
  end

  def team_names
    teams.collect(&:name)
  end

  def requested_to_join?(team)
    join_requests.pending.flat_map(&:joinable).include?(team)
  end

  def is_on?(team)
    teams.include? team
  end

  def bio_complete?
    not bio.blank?
  end

  def after_registration
    RegistrationMailer.welcome_mentor(self).deliver_later
  end
end
