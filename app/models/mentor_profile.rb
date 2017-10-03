class MentorProfile < ActiveRecord::Base
  scope :unmatched, -> {
    select("DISTINCT #{table_name}.*")
      .joins(:current_account)
      .includes(:account)
      .references(:accounts)
      .left_outer_joins(:current_teams)
      .where("teams.id IS NULL")
  }

  scope :in_region, ->(ambassador) {
    if ambassador.country == "US"
      joins(:account)
        .where(
          "accounts.country = ? AND accounts.state_province = ?",
          "US",
          ambassador.state_province
        )
    else
      joins(:account)
        .where("accounts.country = ?", ambassador.country)
    end
  }

  scope :onboarded, -> {
    joins(account: :consent_waiver)
    .includes(account: :background_check)
    .references(:accounts, :background_checks)
    .where(
      "(accounts.country = ?
        AND background_checks.status = ?
          AND accounts.location_confirmed = ?) OR accounts.country != ?",
      "US", BackgroundCheck.statuses[:clear], true, "US"
    )
    .where("accounts.email_confirmed_at IS NOT NULL")
  }

  scope :by_expertise_ids, ->(ids) {
    joins(:mentor_profile_expertises)
    .preload(:mentor_profile_expertises)
    .where("mentor_profile_expertises.expertise_id IN (?)", ids)
    .distinct
  }

  scope :by_gender_identities, ->(ids) {
    ids = ids.compact.map(&:to_i).sort
    male_female = [Account.genders['Male'], Account.genders['Female']].sort
    all_genders = Account.genders.values.sort

    if ids == male_female
      ids = ids + [
        Account.genders["Prefer not to say"],
        Account.genders["Non-binary"]
      ]

      joins(:account).where(
        "accounts.gender IN (?) OR accounts.gender IS NULL",
        ids.uniq
      )
    elsif ids == all_genders
      joins(:account)
        .where("accounts.gender IN (?) OR accounts.gender IS NULL", ids)
    elsif ids.empty?
      where()
    else
      joins(:account).where("accounts.gender IN (?)", ids)
    end
  }

  scope :searchable, ->(mentor_account_id = nil) {
    if !!mentor_account_id
      where(connect_with_mentors: true, searchable: true)
      .where.not(account_id: mentor_account_id)
    else
      where(accepting_team_invites: true, searchable: true)
    end
  }

  scope :virtual, -> { where("mentor_profiles.virtual = ?", true) }

  scope :current, -> {
    joins(:current_account)
  }

  belongs_to :account, touch: true
  accepts_nested_attributes_for :account
  validates_associated :account

  belongs_to :current_account, -> { current },
    foreign_key: :account_id,
    class_name: "Account",
    required: false

  has_many :mentor_profile_expertises,
    dependent: :destroy

  has_many :expertises,
    through: :mentor_profile_expertises

  has_many :memberships,
    as: :member,
    dependent: :destroy

  has_many :teams,
    through: :memberships

  has_many :current_teams, -> { current },
    through: :memberships,
    source: :team

  has_many :past_teams, -> { past },
    through: :memberships,
    source: :team

  has_many :join_requests,
    as: :requestor,
    dependent: :destroy

  has_many :mentor_invites,
    foreign_key: :invitee_id,
    dependent: :destroy

  has_many :team_member_invites,
    foreign_key: :inviter_id

  has_many :declined_join_requests, -> { declined },
    as: :requestor,
    class_name: "JoinRequest"

  has_many :teams_that_declined,
    through: :declined_join_requests,
    as: :requestor,
    source: :team

  reverse_geocoded_by "accounts.latitude", "accounts.longitude"

  after_validation -> { self.searchable = can_enable_searchable? },
    on: :update,
    if: -> { account.country_changed? }

  after_save { teams.current.find_each(&:touch) }
  after_touch { teams.current.find_each(&:touch) }

  validates :school_company_name, :job_title, presence: true
  validates :bio, length: { minimum: 100 }, allow_blank: true, if: :bio_changed?

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

  def youngest_birth_year
    Date.today.year - 15
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
         { Key: 'Country', Value: FriendlyCountry.(self, prefix: false) }]
      )
    end
  end

  def disable_searchability
    update_column(:searchable, false)
  end

  def can_join_a_team?
    consent_signed? and
      background_check_complete? and
        bio_complete? and
          SeasonToggles.team_building_enabled?
  end

  def background_check_complete?
    return true if not requires_background_check?

    background_check.present? and
      background_check.clear?
  end

  def requires_background_check?
    age >= 18 and
      country == "US" and
        not (background_check.present? and background_check.clear?)
  end

  def bio_complete?
    not bio.blank?
  end

  def authenticated?
    true
  end

  def scope_name
    "mentor"
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
    join_requests.pending.flat_map(&:team).include?(team)
  end

  def is_on?(team)
    teams.include?(team)
  end

  def onboarding?
    not onboarded?
  end

  def onboarded?
    account.email_confirmed? and
      consent_signed? and
        background_check_complete? and
          location_confirmed? and
            not bio.blank?
  end

  private
  def can_enable_searchable?
    consent_signed? and background_check_complete?
  end
end
