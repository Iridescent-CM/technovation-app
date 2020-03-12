class Account < ActiveRecord::Base
  MINIMUM_MENTOR_AGE = 14

  # Deprecated in favor of JudgeProfile.suspended flag
  JUDGE_BLOCKLISTED_ACCOUNT_IDS = [
    43662,
    29481,
    46986,
  ]

  enum admin_status: %w{
    not_admin
    temporary_password
    full_admin
  }

  acts_as_paranoid

  include ActiveModel::Validations

  include Seasoned

  include Regioned

  include ActiveGeocoded

  include Casting::Client
  delegate_missing_methods

  include PublicActivity::Common

  attr_accessor :existing_password,
    :skip_existing_password,
    :confirm_sentence,
    :admin_making_changes,
    :inviting_new_admin

  has_one :student_profile, dependent: :destroy
  has_one :mentor_profile, dependent: :destroy
  has_one :judge_profile, dependent: :destroy
  has_one :regional_ambassador_profile, dependent: :destroy

  RegionalAmbassadorProfile.statuses.keys.each do |status|
    has_one "#{status}_regional_ambassador_profile".to_sym,
      -> { send(status) },
      class_name: "RegionalAmbassadorProfile",
      dependent: :destroy
  end

  has_one :admin_profile, dependent: :destroy

  has_one :signup_attempt, dependent: :destroy
  has_one :unconfirmed_email_address, dependent: :destroy

  has_one :consent_waiver, -> { nonvoid }, dependent: :destroy

  belongs_to :division, required: false

  has_many :certificates, dependent: :destroy

  has_many :current_certificates, -> { current }, class_name: "Certificate"

  has_many :participation_certificates, -> { participation },
    class_name: "Certificate"

  has_many :current_participation_certificates, -> { current.participation },
    class_name: "Certificate"

  has_many :completion_certificates, -> { completion },
    class_name: "Certificate"

  has_many :current_completion_certificates, -> { current.completion },
    class_name: "Certificate"

  has_many :semifinalist_certificates, -> { semifinalist },
    class_name: "Certificate"

  has_many :current_semifinalist_certificates, -> { current.semifinalist },
    class_name: "Certificate"

  has_many :appreciation_certificates, -> { mentor_appreciation },
    class_name: "Certificate"

  has_many :current_appreciation_certificates, -> { current.mentor_appreciation },
    class_name: "Certificate"

  has_many :general_judge_certificates, -> { general_judge },
    class_name: "Certificate"

  has_many :current_general_judge_certificates, -> { current.general_judge },
    class_name: "Certificate"

  has_many :certified_judge_certificates, -> { certified_judge },
    class_name: "Certificate"

  has_many :current_certified_judge_certificates, -> { current.certified_judge },
    class_name: "Certificate"

  has_many :head_judge_certificates, -> { head_judge },
    class_name: "Certificate"

  has_many :current_head_judge_certificates, -> { current.head_judge },
    class_name: "Certificate"

  has_many :judge_advisor_certificates, -> { judge_advisor },
    class_name: "Certificate"

  has_many :current_judge_advisor_certificates, -> { current.judge_advisor },
    class_name: "Certificate"

  has_many :judge_certificates, -> { judge_types },
    class_name: "Certificate"

  has_many :current_judge_certificates, -> { current.judge_types },
    class_name: "Certificate"

  has_many :void_consent_waivers,
    -> { void },
    class_name: "ConsentWaiver",
    dependent: :destroy

  has_one :background_check, dependent: :destroy
  accepts_nested_attributes_for :background_check

  enum referred_by: REFERRED_BY_OPTIONS
  enum gender: GENDER_IDENTITY_OPTIONS

  scope :by_query, ->(query) {
    sanitized = sanitize_sql_like(query)
    fname = sanitized.split(" ").first
    lname = sanitized.split(" ").last

    sql = "accounts.first_name ILIKE '#{fname}%'"

    if fname != lname
      sql += " AND "
    else
      sql += " OR "
    end

    sql += "accounts.last_name ILIKE '#{lname}%'"

    where(sql += "OR accounts.email ILIKE '#{sanitized}%'")
  }

  scope :completed_training, -> () {
    includes(:judge_profile)
      .references(:judge_profiles)
      .where.not("judge_profiles.completed_training_at" => nil)
  }

  scope :incomplete_training, -> () {
    includes(:judge_profile)
      .references(:judge_profiles)
      .where("judge_profiles.completed_training_at" => nil)
  }

  scope :mentor_training_required, -> () {
    includes(:mentor_profile)
      .references(:mentor_profiles)
      .where(
        "training_completed_at IS NULL AND " +
          "date(season_registered_at) >= ?",
        ImportantDates.mentor_training_required_since
      )
  }

  scope :mentor_training_complete_or_not_required, -> () {
    includes(:mentor_profile)
      .references(:mentor_profiles)
      .where(
        "training_completed_at IS NOT NULL OR " +
          "date(season_registered_at) < ?",
        ImportantDates.mentor_training_required_since
      )
  }

  scope :live_event_eligible, ->(event) {
    includes(:judge_profile)
      .references(:judge_profiles)
      .left_outer_joins(:mentor_profile, :regional_ambassador_profile)
      .where(
        "judge_profiles.id IS NOT NULL AND " +
        # temporary fix, see: https://github.com/Iridescent-CM/technovation-app/issues/2111
        # "mentor_profiles.id IS NULL AND " +
        "regional_ambassador_profiles.id IS NULL"
      )
  }

  scope :mentors_pending_teams, -> {
    includes(mentor_profile: [:pending_mentor_invites, :pending_join_requests])
    .references(:mentor_profiles, :team_member_invites, :join_requests)
    .where(
      "mentor_profiles.id IS NOT NULL AND " +
      "(team_member_invites.id IS NOT NULL AND " +
      "team_member_invites.status = ?) OR " +
      "(join_requests.id IS NOT NULL AND " +
      "join_requests.accepted_at IS NULL AND  " +
      "join_requests.declined_at IS NULL)",
      TeamMemberInvite.statuses[:pending]
    )
  }

  scope :mentors_pending_invites, -> {
    includes(mentor_profile: :pending_mentor_invites)
    .references(:mentor_profiles, :team_member_invites)
    .where(
      "mentor_profiles.id IS NOT NULL AND " +
      "(team_member_invites.id IS NOT NULL AND " +
      "team_member_invites.status = ?)",
      TeamMemberInvite.statuses[:pending]
    )
  }

  scope :mentors_pending_requests, -> {
    includes(mentor_profile: :pending_join_requests)
    .references(:mentor_profiles, :join_requests)
    .where(
      "mentor_profiles.id IS NOT NULL AND " +
      "(join_requests.id IS NOT NULL AND " +
      "join_requests.accepted_at IS NULL AND  " +
      "join_requests.declined_at IS NULL)"
    )
  }

  scope :onboarded_mentors, -> {
    joins(:mentor_profile)
    .includes(:background_check, :consent_waiver)
    .references(:background_checks, :consent_waivers)
    .where("mentor_profiles.id IS NOT NULL")
    .where(
      "email_confirmed_at IS NOT NULL AND " +
      "mentor_profiles.bio <> '' AND " +
      "mentor_profiles.mentor_type IS NOT NULL AND " +
      "(consent_waivers.id IS NOT NULL AND consent_waivers.voided_at IS NULL) AND " +
      "(training_completed_at IS NOT NULL OR date(season_registered_at) < ?) AND " +
      "((country = 'US' AND background_checks.status = ?) OR country != 'US')",
      ImportantDates.mentor_training_required_since,
      BackgroundCheck.statuses[:clear]
    )
  }

  scope :onboarding_mentors, -> {
    joins(:mentor_profile)
    .references(:mentor_profiles)
    .includes(:background_check, :consent_waiver)
    .references(:background_checks, :consent_waivers)
    .where(
      "email_confirmed_at IS NULL OR " +
      "mentor_profiles.bio IS NULL OR mentor_profiles.bio = '' OR " +
      "mentor_profiles.mentor_type IS NULL OR " +
      "(consent_waivers.id IS NULL OR consent_waivers.voided_at IS NOT NULL) OR " +
      "(training_completed_at IS NULL and date(season_registered_at) >= ?) OR " +
      "(country = 'US' AND (background_checks.status != ? OR background_checks.status IS NULL))",
      ImportantDates.mentor_training_required_since,
      BackgroundCheck.statuses[:clear]
    )
  }

  after_commit -> {
    if saved_change_to_email_confirmed_at ||
         saved_change_to_latitude ||
           saved_change_to_city

      # TODO - Move this out of here so that this logic fires whent the record is touched.
      if student_profile.present?
        student_profile.update_column(
          :onboarded,
          student_profile.can_be_marked_onboarded?
        )
      elsif judge_profile.present?
        judge_profile.update_column(
          :onboarded,
          judge_profile.can_be_marked_onboarded?
        )
      end

    end

    if saved_change_to_first_name || saved_change_to_last_name
      current_certificates.destroy_all
    end
  }

  after_initialize :populate_terms_agreed_from_signup_attempt

  def self.sort_column
    :first_name
  end

  def assign_address_details(geocoded)
    self.city = geocoded.city
    self.state_province = geocoded.state_code
    self.country = geocoded.country_code
  end

  def random_id
    SecureRandom.hex(4)
  end

  def virtual_event?
    #FIXME: this method doesn't feel right at all
    judge_profile.present? && judge_profile.regional_pitch_events.any? { |e| e.virtual? }
  end

  def reset_location!
    update(
      city: nil,
      state_province: nil,
      country: nil,
      latitude: nil,
      longitude: nil,
    )
  end

  def ambassador_route_key
    :participant
  end

  def event_scope
    "JudgeProfile"
  end

  def id_for_event
    judge_profile.id
  end

  def assigned_teams
    (judge_profile and judge_profile.assigned_teams) or
      Team.none
  end

  def regional_ambassador
    ra = ::NullRegionalAmbassador.new

    if valid_address?
      ra = find_regional_ambassador_by_state

      unless ra.present?
        ra = find_regional_ambassador_by_country
      end
    end

    ra
  end

  scope :not_staff, -> {
    where.not("accounts.email ILIKE ?", "%joesak%")
  }

  scope :inactive_mentors, -> {
    current.joins(:mentor_profile)
      .joins(
        "LEFT OUTER JOIN activities
        ON activities.trackable_id = accounts.id
        AND activities.trackable_type = 'Account'
        AND activities.created_at > '#{3.weeks.ago}'"
      )
      .where("activities.id IS NULL")
  }

  scope :inactive_students, -> {
    current.joins(:student_profile)
      .joins(
        "LEFT OUTER JOIN activities
        ON activities.trackable_id = accounts.id
        AND activities.trackable_type = 'Account'
        AND activities.created_at > '#{3.weeks.ago}'"
      )
      .where("activities.id IS NULL")
  }

  scope :confirmed_email, -> { where("email_confirmed_at IS NOT NULL") }
  scope :unconfirmed_email, -> { where("email_confirmed_at IS NULL") }

  scope :matched, -> {
    mentor_ids = unscoped.distinct
      .joins(mentor_profile: :current_teams).pluck(:id)

    student_ids = unscoped.distinct
      .joins(student_profile: :current_teams).pluck(:id)

    where(id: mentor_ids + student_ids)
  }

  scope :unmatched, -> {
    mentor_ids = unscoped.distinct
      .joins(mentor_profile: :current_teams).pluck(:id)

    student_ids = unscoped.distinct
      .joins(student_profile: :current_teams).pluck(:id)


    left_outer_joins(:judge_profile, :regional_ambassador_profile)
      .where("judge_profiles.id IS NULL AND regional_ambassador_profiles.id IS NULL")
      .where.not(id: mentor_ids + student_ids)
  }

  scope :parental_consented, ->(*seasons) {
    seasons.push(Season.current.year) if seasons.empty?

    season_clauses = seasons.flatten.map do |season|
      "'#{season}' = ANY (parental_consents.seasons)"
    end

    left_outer_joins(student_profile: :parental_consents)
      .where("student_profiles.id IS NOT NULL")
      .where(season_clauses.join(' AND '))
      .where(
        "parental_consents.status = ?",
        ParentalConsent.statuses[:signed]
      )
  }

  scope :not_parental_consented, ->(*seasons) {
    seasons.push(Season.current.year) if seasons.empty?

    season_clauses = seasons.flatten.map do |season|
      "('#{season}' = ANY (parental_consents.seasons) AND parental_consents.status = '#{ParentalConsent.statuses[:pending]}')"
    end

    left_outer_joins(student_profile: :parental_consents)
      .where("student_profiles.id IS NOT NULL")
      .where(season_clauses.join(' OR '))
  }

  scope :consent_signed, -> {
    left_outer_joins(:mentor_profile, :consent_waiver)
      .where("mentor_profiles.id IS NOT NULL")
      .where("consent_waivers.id IS NOT NULL")
  }

  scope :consent_not_signed, -> {
    left_outer_joins(:mentor_profile, :consent_waiver)
      .where("mentor_profiles.id IS NOT NULL")
      .where("consent_waivers.id IS NULL")
  }

  scope :bg_check_unsubmitted, -> {
    left_outer_joins(:mentor_profile, :background_check)
      .where("accounts.country = 'US'")
      .where("mentor_profiles.id IS NOT NULL")
      .where("background_checks.id IS NULL")
  }

  scope :bg_check_submitted, -> {
    left_outer_joins(:mentor_profile, :background_check)
      .where("accounts.country = 'US'")
      .where("mentor_profiles.id IS NOT NULL")
      .where("background_checks.id IS NOT NULL")
      .where("background_checks.status = ?", BackgroundCheck.statuses[:pending])
  }

  scope :bg_check_clear, -> {
    left_outer_joins(:mentor_profile, :background_check)
      .where("mentor_profiles.id IS NOT NULL")
      .where(
        "accounts.country != 'US' OR (
          accounts.country = 'US' AND
            background_checks.id IS NOT NULL AND
              background_checks.status = ?)",
        BackgroundCheck.statuses[:clear]
      )
  }

  scope :bg_check_consider, -> {
    left_outer_joins(:mentor_profile, :background_check)
      .where("accounts.country = 'US'")
      .where("mentor_profiles.id IS NOT NULL")
      .where("background_checks.id IS NOT NULL")
      .where("background_checks.status = ?", BackgroundCheck.statuses[:consider])
  }

  scope :bg_check_suspended, -> {
    left_outer_joins(:mentor_profile, :background_check)
      .where("accounts.country = 'US'")
      .where("mentor_profiles.id IS NOT NULL")
      .where("background_checks.id IS NOT NULL")
      .where("background_checks.status = ?", BackgroundCheck.statuses[:suspended])
  }

  scope :by_division, ->(division) {
    left_outer_joins(:division,:student_profile)
      .where("student_profiles.id IS NOT NULL")
      .where("divisions.id IS NOT NULL")
      .where("divisions.name = ?", Division.names[division])
  }

  mount_uploader :profile_image, ImageProcessor

  has_secure_token :auth_token
  has_secure_token :consent_token
  has_secure_token :password_reset_token
  has_secure_token :session_token
  has_secure_token :mailer_token
  has_secure_token :admin_invitation_token
  has_secure_password

  before_validation -> {
    self.email = email.to_s.strip.downcase

    if !!inviting_new_admin
      self.password = SecureRandom.hex(12)
      self.admin_status = :temporary_password
    end
  }

  validates :email,
    presence: true,
    email: true

  validates_uniqueness_of :email,
    case_sensitive: false,
    scope: :deleted_at

  validates :profile_image, verify_cached_file: true

  validates :existing_password,
    valid_password: true,
    if: :changes_require_password?

  validates :password,
    length: {
      minimum: 8,
      on: :create,
      if: :temporary_password?
    }

  validates :password,
    length: {
      minimum: 8,
      on: :update,
      if: -> { not_admin? && changing_password_or_temporary_password? }
    }

  validates :password,
    length: {
      minimum: 20,
      on: :update,
      if: -> { !full_admin? && !not_admin? }
    }

  validates :date_of_birth, :first_name, :last_name, presence: true

  validates :gender, presence: true, if: -> { not_student? }

  validate -> {
    errors.add(:email, :taken) if Account.where.not(id: id).exists?([
      "replace(email, '.', '') = ?",
      email.gsub(".", "")
    ])
  }

  validates_with StudentEmailValidator

  def self.find_with_token(token)
    find_by(auth_token: token) || ::NullAuth.new
  end

  def self.find_judge_profile_id_by_email(email)
    find_by(email: email).judge_profile.id
  end

  def self.find_profile_with_token(token, profile)
    "#{String(profile).camelize}Account".constantize
      .find_by(
        auth_token: token
      ) or ::NullAuth.new
  end

  def profile_school_company_name
    if student_profile
      student_profile.school_name
    elsif regional_ambassador_profile
      regional_ambassador_profile.organization_company_name
    elsif mentor_profile
      mentor_profile.school_company_name
    elsif judge_profile
      judge_profile.company_name
    else
      false
    end
  end

  def profile_team_names
    if student_profile
      student_profile.team_names
    elsif mentor_profile
      mentor_profile.team_names
    else
      []
    end
  end

  def profile_teams
    if student_profile && student_profile.team.present?
      [student_profile.team]
    elsif mentor_profile
      mentor_profile.teams
    else
      []
    end
  end

  def profile_job_title
    if student_profile
      false
    elsif regional_ambassador_profile
      regional_ambassador_profile.job_title
    elsif mentor_profile
      mentor_profile.job_title
    elsif judge_profile
      judge_profile.job_title
    else
      false
    end
  end

  def profile_mentor_type
    if mentor_profile
      mentor_profile.mentor_type
    else
      false
    end
  end

  def profile_expertise_ids
    if mentor_profile
      mentor_profile.expertise_ids
    else
      []
    end
  end

  def events
    judge_profile && judge_profile.events ||

      regional_ambassador_profile &&
        regional_ambassador_profile.regional_pitch_events
  end

  def in_event?(event)
    events.include?(event)
  end

  def status
    judge_profile && judge_profile.status
  end

  def human_status
    judge_profile && judge_profile.human_status
  end

  def status_explained
    judge_profile && judge_profile.status_explained
  end

  def friendly_status
    judge_profile && judge_profile.friendly_status
  end

  def avatar_url
    profile_image_url
  end
  alias :avatar :avatar_url

  def took_survey!
    update(survey_completed_at: Time.current)
  end

  def took_program_survey!
    update(pre_survey_completed_at: Time.current)
  end

  def took_program_survey?
    !!pre_survey_completed_at
  end

  def took_survey?
    !!survey_completed_at
  end

  def needs_survey_reminder?
    if reminded_about_survey_at.blank?
      !!season_registered_at and
        season_registered_at < self.class.survey_reminder_period
    else
      reminded_about_survey_count < self.class.survey_reminder_max_times and
        reminded_about_survey_at <= self.class.survey_reminder_period
    end
  end

  def reminded_about_survey!
    update_columns(
      reminded_about_survey_at: Time.current,
      reminded_about_survey_count: reminded_about_survey_count + 1,
    )
  end

  def profile_image_url
    icon_path.blank? ? super : icon_path
  end

  def can_be_a_mentor?(**options)
    !mentor_profile.present? &&
      (judge_profile.present? ||
        regional_ambassador_profile.present? ||
          (options[:admin] && student_profile.present? && age >= MINIMUM_MENTOR_AGE))
  end

  def can_be_a_judge?
    not student_profile.present? and
      not JUDGE_BLOCKLISTED_ACCOUNT_IDS.include?(id) and
        regional_ambassador_profile.present? or
          mentor_profile.present?
  end

  def is_a_judge?
    judge_profile.present?
  end

  def is_not_a_judge?
    not judge_profile.present?
  end

  def is_a_mentor?
    mentor_profile.present?
  end

  def is_an_ambassador?
    regional_ambassador_profile.present?
  end
  alias :is_ra? :is_an_ambassador?

  def is_admin?
    admin_profile.present?
  end

  def can_switch_to_judge?
    if is_an_ambassador?
      !!ENV.fetch("ENABLE_RA_SWITCH_TO_JUDGE", false) && is_a_judge?
    elsif is_a_mentor?
      !!ENV.fetch("ENABLE_SWITCH_BETWEEN_JUDGE_AND_MENTOR", false)
    else
      false
    end
  end

  def can_switch_to_mentor?
    if is_an_ambassador?
      true
    elsif is_a_judge?
      !!ENV.fetch("ENABLE_SWITCH_BETWEEN_JUDGE_AND_MENTOR", false)
    else
      false
    end
  end

  def email_confirmed!
    update(email_confirmed_at: Time.current)
  end

  def email_confirmed?
    !!email_confirmed_at
  end

  def profile_valid?
    if student_profile
      student_profile.valid?
    elsif mentor_profile
      mentor_profile.valid?
    elsif regional_ambassador_profile
      regional_ambassador_profile.valid?
    elsif judge_profile
      judge_profile.valid?
    end
  end

  def photo_url
    profile_image_url
  end

  def name
    full_name
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def oldest_birth_year
    Date.today.year - 80
  end

  def youngest_birth_year
    Date.today.year - 18
  end

  def enable_password_reset!
    regenerate_password_reset_token
    update_column(:password_reset_token_sent_at, Time.current)
  end

  def get_school_company_name
    if student_profile
      student_profile.school_name
    elsif judge_profile
      judge_profile.company_name
    elsif mentor_profile
      mentor_profile.school_company_name
    elsif regional_ambassador_profile
      regional_ambassador_profile.organization_company_name
    end
  end

  def parent_email
    if student_profile
      student_profile.parent_guardian_email
    end
  end

  def parental_consent(season = Season.current.year)
    if student_profile
      student_profile.parental_consents.by_season(season).first
    end
  end

  def age(now = Time.current.to_date)
    current_month_after_birth_month = now.month > date_of_birth.month
    current_month_is_birth_month = now.month == date_of_birth.month
    current_day_is_on_or_after_birthday = now.day >= date_of_birth.day

    extra_year = (current_month_after_birth_month ||
                    (current_month_is_birth_month &&
                       current_day_is_on_or_after_birthday)) ? 0 : 1

    now.year - date_of_birth.year - extra_year
  end

  def age_by_cutoff
    age(Division.cutoff_date)
  end

  def temporary_password?
    if new_record?
      SignupAttempt.temporary_password.where(
        "lower(email) = ?", email.downcase
      ).exists? || UserInvitation.exists?(email: email)
    else
      super || (signup_attempt.present? && signup_attempt.temporary_password?)
    end
  end

  def type_name(*args)
    ActiveSupport::Deprecation.warn(
      "Account#type_name is deprecated. Use View helper #current_scope (preferred) or Account#scope_name if absolutely necessary"
    )
    scope_name(*args)
  end

  def scope_name(module_name = nil)
    # TODO: this doesn't work well for accounts with multiple scopes
    if module_name and module_name === "judge"
      "judge"
    elsif regional_ambassador_profile.present? and
            regional_ambassador_profile.approved?
      "regional_ambassador"
    elsif mentor_profile.present?
      "mentor"
    elsif student_profile.present?
      "student"
    elsif judge_profile.present?
      "judge"
    elsif admin_profile.present?
      "admin"
    elsif regional_ambassador_profile.present?
      "#{regional_ambassador_profile.status}_regional_ambassador"
    else
      "public"
    end
  end

  def consent_signed?
    consent_waiver.present? and
      consent_waiver.signed?
  end

  def consent_waiver
    super || ::NullConsentWaiver.new
  end

  def background_check
    super || ::NullBackgroundCheck.new
  end

  def authenticated?
    true
  end

  def admin?
    admin_profile.present?
  end

  def terms_agreed?
    !!terms_agreed_at
  end

  def populate_terms_agreed_from_signup_attempt
    if !self.terms_agreed? && self.signup_attempt && self.signup_attempt.terms_agreed?
      self.terms_agreed_at = self.signup_attempt.terms_agreed_at
      self.save
    end
  end

  def set_terms_agreed(bool)
    value = bool ? Time.current : nil
    self.terms_agreed_at = value
    self.save
  end

  def teams
    if student_profile
      student_profile.teams
    elsif mentor_profile
      mentor_profile.teams
    elsif judge_profile
      judge_profile.assigned_teams
    else
      ::NullTeams.new
    end
  end

  def current_teams
    if student_profile
      student_profile.current_teams
    elsif mentor_profile
      mentor_profile.current_teams
    else
      ::NullTeams.new
    end
  end

  def past_teams
    if student_profile
      student_profile.past_teams
    elsif mentor_profile
      mentor_profile.past_teams
    else
      ::NullTeams.new
    end
  end

  def team_region_division_names
    team_keys = teams.current.map(&:cache_key).join('/')

    Rails.cache.fetch("#{team_keys}/team_region_division_names") do
      teams.current.map(&:region_division_name).uniq
    end
  end

  def update_address_details_from_reverse_geocoding(results)
    if geo = results.first
      self.city = geo.city
      self.state_province = geo.state_code
      country = Country.find_country_by_name(geo.country_code) ||
                  Country.find_country_by_alpha3(geo.country_code) ||
                    Country.find_country_by_alpha2(geo.country_code)
      self.country = country && country.alpha2
    end
  end

  def email_is_changing?
    !!will_save_change_to_email? and
      email_was.strip.downcase != email.strip.downcase
  end

  def returning?
    seasons.length > 1
  end

  def student?
    student_profile.present? and
      !(mentor_profile.present? or judge_profile.present?)
  end

  private
  def self.survey_reminder_max_times
    2
  end

  def self.survey_reminder_period
    2.days.ago
  end

  def changes_require_password?
    !!!skip_existing_password &&
      !!!inviting_new_admin &&
        (persisted? && (email_is_changing? || changing_password?))
  end

  def changing_password?
    !!!skip_existing_password && (persisted? && will_save_change_to_password_digest?)
  end

  def changing_password_or_temporary_password?
    changing_password? || temporary_password?
  end

  def not_student?
    !student_profile.present?
  end

  def find_regional_ambassador_by(query)
    results = Account.current
      .joins(:approved_regional_ambassador_profile)
      .not_staff
      .where(
        "regional_ambassador_profiles.intro_summary NOT IN ('')
        AND regional_ambassador_profiles.intro_summary IS NOT NULL"
      )
      .where(query)

    if address_details.blank?
      account = results.first
    else
      account = results
        .near(
          address_details,
          SearchMentors::EARTH_CIRCUMFERENCE
        )
        .first
    end

    if account
      account.regional_ambassador_profile
    else
      ::NullRegionalAmbassador.new
    end
  end

  def find_regional_ambassador_by_state
    find_regional_ambassador_by({
      "accounts.country" => country_code,
      "accounts.state_province" => state_code
    })
  end

  def find_regional_ambassador_by_country
    if country == "US"
      ::NullRegionalAmbassador.new
    else
      find_regional_ambassador_by({
        "accounts.country" => country_code
      })
    end
  end
end
