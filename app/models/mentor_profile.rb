class MentorProfile < ActiveRecord::Base
  scope :full_access, -> {
    joins(account: :consent_waiver)
    .includes(account: :background_check)
    .references(:accounts, :background_checks)
    .where(
      "(accounts.country = ?
        AND background_checks.status = ?
          AND accounts.location_confirmed = ?) OR accounts.country != ?",
      "US", BackgroundCheck.statuses[:clear], true, "US"
    )
  }

  scope :by_expertise_ids, ->(ids) {
    joins(:mentor_profile_expertises)
    .preload(:mentor_profile_expertises)
    .where("mentor_profile_expertises.expertise_id IN (?)", ids)
    .uniq
  }

  scope :by_gender_identities, ->(ids) {
    ids = ids.compact.map(&:to_i).sort
    male_female = [Account.genders['Male'], Account.genders['Female']].sort
    all_genders = Account.genders.values.sort

    if ids == male_female
      ids = ids + [Account.genders["Prefer not to say"], Account.genders["Non-binary"]]
      joins(:account).where("accounts.gender IN (?) OR accounts.gender IS NULL", ids.uniq)
    elsif ids == all_genders
      joins(:account).where("accounts.gender IN (?) OR accounts.gender IS NULL", ids)
    else
      joins(:account).where("accounts.gender IN (?)", ids)
    end
  }

  scope :searchable, ->(user = nil) {
    if user and user.type_name == "mentor"
      where(connect_with_mentors: true, searchable: true)
      .where.not(account_id: user.account_id)
    else
      where(accepting_team_invites: true, searchable: true)
    end
  }

  scope :virtual, -> { where("mentor_profiles.virtual = ?", true) }

  scope :current, -> {
    joins(account: { season_registrations: :season })
    .where("season_registrations.status = ? AND seasons.year = ?",
           SeasonRegistration.statuses[:active],
           Season.current.year)
  }

  belongs_to :account
  accepts_nested_attributes_for :account
  validates_associated :account

  has_many :mentor_profile_expertises, dependent: :destroy
  has_many :expertises, through: :mentor_profile_expertises

  has_many :memberships, as: :member, dependent: :destroy
  has_many :teams, through: :memberships, source: :joinable, source_type: "Team"

  has_many :join_requests, as: :requestor, dependent: :destroy
  has_many :mentor_invites, foreign_key: :invitee_id, dependent: :destroy
  has_many :team_member_invites, foreign_key: :inviter_id

  reverse_geocoded_by "accounts.latitude", "accounts.longitude"

  after_validation -> { self.searchable = can_enable_searchable? },
    on: :update,
    if: -> { account.country_changed? }

  validates :school_company_name, :job_title, presence: true

  delegate :submitted?,
           :candidate_id,
           :report_id,
    to: :background_check,
    prefix: true,
    allow_nil: true

  def method_missing(method_name, *args)
    begin
      account.public_send(method_name, *args)
    rescue
      raise NoMethodError, "undefined method `#{method_name}' not found for #{self}"
    end
  end

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
      SubscribeEmailListJob.perform_later(
        account.email,
        account.full_name,
        "MENTOR_LIST_ID",
        [{ Key: 'City', Value: city },
         { Key: 'State/Province', Value: state_province },
         { Key: 'Country', Value: Country[country].name }]
      )
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

  def bio_complete?
    not bio.blank?
  end

  def authenticated?
    true
  end

  def type_name
    "mentor"
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
    consent_signed? and
      background_check_complete? and
        location_confirmed? and
          not bio.blank?
  end

  private
  def can_enable_searchable?
    consent_signed? and background_check_complete? and location_confirmed?
  end
end
