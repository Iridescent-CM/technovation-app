class MentorAccount < Account
  default_scope { eager_load(:mentor_profile) }

  has_one :mentor_profile, foreign_key: :account_id, dependent: :destroy
  accepts_nested_attributes_for :mentor_profile
  validates_associated :mentor_profile

  has_one :background_check, foreign_key: :account_id, dependent: :destroy
  accepts_nested_attributes_for :background_check

  has_many :memberships, as: :member, dependent: :destroy

  has_many :join_requests, as: :requestor, dependent: :destroy
  has_many :mentor_invites, foreign_key: :invitee_id, dependent: :destroy
  has_many :team_member_invites, foreign_key: :inviter_id

  scope :by_expertise_ids, ->(ids) {
    joins(mentor_profile: :mentor_profile_expertises)
    .preload(mentor_profile: :mentor_profile_expertises)
    .where("mentor_profile_expertises.expertise_id IN (?)", ids)
    .uniq
  }

  scope :searchable, -> { where("mentor_profiles.accepting_team_invites = ? AND mentor_profiles.searchable = ?", true, true) }
  scope :virtual, -> { where("mentor_profiles.virtual = ?", true) }

  delegate :expertises,
           :expertise_names,
           :job_title,
           :school_company_name,
           :bio,
           :enable_searchability,
           :virtual?,
    to: :mentor_profile,
    prefix: false

  delegate :id, to: :mentor_profile, prefix: true

  delegate :submitted?,
           :candidate_id,
           :report_id,
    to: :background_check,
    prefix: true,
    allow_nil: true

  def after_background_check_clear
    AccountMailer.background_check_clear(self).deliver_later
    mentor_profile.enable_searchability
  end

  def after_background_check_deleted
    mentor_profile.disable_searchability
  end

  def background_check_complete?
    country != "US" or !!background_check && background_check.clear?
  end

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
    @teams ||= Team.eager_load(:memberships).where('memberships.member_id = ?', id)
  end

  def team_ids
    teams.current.collect(&:id)
  end

  def can_join_a_team?
    consent_signed? && background_check_complete? && bio_complete?
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
    super
    RegistrationMailer.welcome_mentor(self).deliver_later
  end
end
