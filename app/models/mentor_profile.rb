class MentorProfile < ActiveRecord::Base
  scope :full_access, -> {
    joins(:consent_waiver)
    .includes(:background_check)
    .references(:background_checks)
    .where(
      "(accounts.country = ? AND background_checks.status = ?) OR accounts.country != ?",
      "US", BackgroundCheck.statuses[:clear], "US"
    )
  }

  scope :by_expertise_ids, ->(ids) {
    joins(mentor_profile: :mentor_profile_expertises)
    .preload(mentor_profile: :mentor_profile_expertises)
    .where("mentor_profile_expertises.expertise_id IN (?)", ids)
    .uniq
  }

  scope :searchable, -> {
    where(
      "mentor_profiles.accepting_team_invites = ? AND mentor_profiles.searchable = ?",
      true, true
    )
  }

  scope :virtual, -> { where("mentor_profiles.virtual = ?", true) }

  belongs_to :account

  has_many :mentor_profile_expertises, dependent: :destroy
  has_many :expertises, through: :mentor_profile_expertises

  has_one :honor_code_agreement,
    -> { nonvoid },
    foreign_key: :account_id,
    dependent: :destroy

  has_one :background_check, foreign_key: :account_id, dependent: :destroy
  accepts_nested_attributes_for :background_check

  has_one :mentor_profile, foreign_key: :account_id, dependent: :destroy
  accepts_nested_attributes_for :mentor_profile
  validates_associated :mentor_profile

  has_many :memberships, as: :member, dependent: :destroy

  has_many :join_requests, as: :requestor, dependent: :destroy
  has_many :mentor_invites, foreign_key: :invitee_id, dependent: :destroy
  has_many :team_member_invites, foreign_key: :inviter_id

  has_one :consent_waiver, foreign_key: :account_id, dependent: :destroy

  after_validation -> { self.searchable = can_enable_searchable? },
    on: :update,
    if: -> { account.country_changed? }

  validates :school_company_name, :job_title, presence: true

  delegate :country, to: :account

  delegate :submitted?,
           :candidate_id,
           :report_id,
    to: :background_check,
    prefix: true,
    allow_nil: true

  def expertise_names
    expertises.flat_map(&:name)
  end

  def background_check_submitted?
    !!background_check_candidate_id and !!background_check_report_id
  end

  def enable_searchability
    update_attributes(searchable: can_enable_searchable?)

    if can_enable_searchable?
      RegistrationMailer.welcome_mentor(account).deliver_later
      SubscribeEmailListJob.perform_later(account.email,
                                          account.full_name,
                                          "MENTOR_LIST_ID")
    end
  end

  def disable_searchability
    update_column(:searchable, false)
  end

  def can_join_a_team?
    honor_code_signed? && consent_signed? && background_check_complete? && bio_complete?
  end

  def background_check_complete?
    country != "US" or (background_check.present? and background_check.clear?)
  end

  def honor_code_signed?
    honor_code_agreement.present?
  end

  def bio_complete?
    not bio.blank?
  end

  def authenticated?
    true
  end

  def type_name
    "mentor"
  end

  def consent_signed?
    consent_waiver.present?
  end

  def void_honor_code_agreement!
    honor_code_agreement.void!
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

  def team_names
    teams.collect(&:name)
  end

  def requested_to_join?(team)
    join_requests.pending.flat_map(&:joinable).include?(team)
  end

  def is_on?(team)
    teams.include? team
  end

  def full_access_enabled?
    consent_signed? and background_check_complete? and not bio.blank?
  end

  private
  def can_enable_searchable?
    consent_signed? and background_check_complete?
  end
end
