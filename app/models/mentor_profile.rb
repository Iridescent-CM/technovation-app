class MentorProfile < ActiveRecord::Base
  attr_accessor :used_global_invitation
  include Regioned
  regioned_source Account

  scope :unmatched, -> {
    select("DISTINCT #{table_name}.*")
      .joins(:current_account)
      .includes(:account)
      .references(:accounts)
      .left_outer_joins(:current_teams)
      .where("teams.id IS NULL")
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
      current.where(connect_with_mentors: true, searchable: true)
        .where.not(account_id: mentor_account_id)
    else
      current.where(accepting_team_invites: true, searchable: true)
    end
  }

  scope :virtual, -> { where("mentor_profiles.virtual = ?", true) }

  scope :current, -> {
    joins(:current_account)
  }

  belongs_to :account,
    touch: true,
    required: false

  belongs_to :user_invitation,
    required: false

  accepts_nested_attributes_for :account
  validates_associated :account, if: -> { user_invitation.blank? }

  before_validation -> {
    if account.blank? and user_invitation.blank?
      errors.add(:account, "is required unless there's a user invitation")
      errors.add(
        :user_invitation,
        "is required unless there's an account"
      )
    end
  }

  belongs_to :current_account, -> { current },
    foreign_key: :account_id,
    class_name: "Account",
    required: false

  has_many :mentor_profile_expertises,
    dependent: :destroy

  has_many :expertises,
    through: :mentor_profile_expertises

  has_many :mentor_profile_mentor_types,
    dependent: :destroy

  has_many :mentor_types,
    through: :mentor_profile_mentor_types

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

  has_many :team_submissions, through: :teams

  has_many :join_requests,
    as: :requestor,
    dependent: :destroy

  has_many :pending_join_requests,
    -> { pending },
    as: :requestor,
    class_name: "JoinRequest",
    dependent: :destroy

  has_many :mentor_invites,
    foreign_key: :invitee_id,
    dependent: :destroy

  has_many :pending_mentor_invites,
    -> { pending },
    foreign_key: :invitee_id,
    class_name: "MentorInvite"

  has_many :team_member_invites,
    foreign_key: :inviter_id

  has_many :declined_join_requests, -> { declined },
    as: :requestor,
    class_name: "JoinRequest"

  has_many :teams_that_declined,
    through: :declined_join_requests,
    as: :requestor,
    source: :team

  has_many :jobs, as: :owner

  reverse_geocoded_by "accounts.latitude", "accounts.longitude"

  before_validation -> { enable_searchability }, on: :update

  after_save { current_teams.find_each(&:touch) }
  after_touch { current_teams.find_each(&:touch) }

  validates :school_company_name,
    :job_title,
    :mentor_types,
    presence: true

  validates :bio,
    length: { minimum: 100 },
    allow_blank: true

  delegate :submitted?,
           :candidate_id,
           :report_id,
           :invitation_id,
    to: :background_check,
    prefix: true,
    allow_nil: true

  def method_missing(method_name, *args)
    account.public_send(method_name, *args)
  end

  def training_required?
    if !season_registered_at && seasons.include?(Season.current.year)
      account.update_column(:season_registered_at, Time.current)
    end

    if season_registered_at
      season_registered_at.to_date >=
        ImportantDates.mentor_training_required_since.to_date
    else
      false
    end
  end

  def training_complete?
    !!training_completed_at
  end

  def training_complete_or_not_required?
    training_complete? || !training_required?
  end

  def complete_training!
    update(training_completed_at: Time.current)
  end

  def onboarding_steps
    steps = []

    methods = [
      :email_confirmed?,
      :training_complete_or_not_required?,
      :consent_signed?,
      :background_check_complete?,
      :bio_complete?,
    ]

    methods.each do |method|
      if !send(method)
        steps.push(method)
      end
    end

    steps
  end

  def has_completed_action?(action)
    case action.name
    when :join_team
      is_on_team?
    else
      raise "Implement MentorProfile#has_completed_action? case for :#{action.name}"
    end
  end

  def status
    if current_account && onboarded?
      "ready"
    elsif current_account
      "registered"
    else
      "past_season"
    end
  end

  def human_status
    case status
    when "past_season"; "must log in"
    when "registered";  "must complete onboarding"
    when "ready";       "ready!"
    else; "status missing (bug)"
    end
  end

  def friendly_status
    case status
    when "past_season"; "Log in now"
    when "registered";  "Complete your mentor profile"
    when "ready";       "Log in for more details"
    else; "status missing (bug)"
    end
  end

  def used_global_invitation?
    !!used_global_invitation
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
    self.searchable = can_enable_searchable?

    yield(self) if block_given?
  end

  def enable_searchability_with_save
    enable_searchability(&:save)
  end

  def disable_searchability
    update_column(:searchable, false)
  end

  def can_join_a_team?
    onboarded? &&
            SeasonToggles.team_building_enabled?
  end
  alias :can_create_a_team? :can_join_a_team?

  def background_check_complete?
    return true if not requires_background_check?

    background_check.present? and
      background_check.clear?
  end

  def requires_background_check?
    (account.valid? && account.age >= 18) &&
      in_background_check_country? &&
      !(background_check.present? && background_check.clear?)
  end

  def in_background_check_country?
    country_codes = ENV.fetch("BACKGROUND_CHECK_COUNTRY_CODES", "").split(",")
    country_codes.include?(account.country_code)
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
    current_teams.any?
  end

  def team_ids
    current_teams.collect(&:id)
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

  def rebranded?
    false
  end

  def onboarding?
    not onboarded?
  end

  def onboarded?
    account.present? &&
      account.email_confirmed? &&
        training_complete_or_not_required? &&
          consent_signed? &&
            background_check_complete? &&
                !bio.blank?
  end

  private

  def can_enable_searchable?
    onboarded?
  end
end
