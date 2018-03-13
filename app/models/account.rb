class Account < ActiveRecord::Base
  include Seasoned

  include Regioned

  include Casting::Client
  delegate_missing_methods

  include PublicActivity::Common

  geocoded_by :address_details
  reverse_geocoded_by :latitude, :longitude do |account, results|
    account.update_address_details_from_reverse_geocoding(results)
  end

  attr_accessor :existing_password,
    :skip_existing_password,
    :confirm_sentence,
    :admin_making_changes

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

  has_many :void_consent_waivers,
    -> { void },
    class_name: "ConsentWaiver",
    dependent: :destroy

  has_one :background_check, dependent: :destroy
  accepts_nested_attributes_for :background_check

  enum referred_by: %w{
    Friend
    Colleague
    Article
    Internet
    Social\ media
    Print
    Web\ search
    Teacher
    Parent/family
    Company\ email
    Made\ With\ Code
    Other
  }

  enum gender: %w{
    Female
    Male
    Non-binary
    Prefer\ not\ to\ say
  }

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

  scope :live_event_eligible, ->(event) {
    includes(:judge_profile)
      .references(:judge_profiles)
      .left_outer_joins(:mentor_profile, :regional_ambassador_profile)
      .where(
        "judge_profiles.id IS NOT NULL AND " +
        "mentor_profiles.id IS NULL AND " +
        "regional_ambassador_profiles.id IS NULL"
      )
  }

  def self.sort_column
    :first_name
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

    distinct
      .left_outer_joins(student_profile: :parental_consents)
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

    distinct
      .left_outer_joins(student_profile: :parental_consents)
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
  has_secure_password

  before_validation -> {
    self.email = email.to_s.strip.downcase
  }

  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false },
    email: true

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
      if: :changing_password_or_temporary_password?
    }

  validates :date_of_birth, :first_name, :last_name, presence: true

  validate -> {
    errors.add(:email, :taken) if Account.where.not(id: id).exists?([
      "replace(email, '.', '') = ?",
      email.gsub(".", "")
    ])
  }

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

  def events
    judge_profile && judge_profile.events
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

  def took_survey!
    update_column(:survey_completed_at, Time.current)
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

  def can_be_a_mentor?
    judge_profile.present? or regional_ambassador_profile.present?
  end

  def is_not_a_mentor?
    not mentor_profile.present?
  end

  def is_an_ambassador?
    regional_ambassador_profile.present?
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

  def address_details
    [
      city,
      state_province,
      Country[country].try(:name)
    ].reject(&:blank?).join(', ')
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
      ).exists? or UserInvitation.exists?(email: email)
    else
      signup_attempt.present? and signup_attempt.temporary_password?
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
      "application"
    end
  end

  def consent_signed?
    consent_waiver.present? and
      consent_waiver.signed?
  end

  def consent_waiver
    super || ::NullConsentWaiver.new
  end

  def authenticated?
    true
  end

  def admin?
    admin_profile.present?
  end

  def teams
    if student_profile
      student_profile.teams
    elsif mentor_profile
      mentor_profile.teams
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
      self.country = country.alpha2
    end
  end

  def email_changed?
    !!email_was and
      email_was.strip.downcase != email.strip.downcase and
        super
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
      (persisted? && (email_changed? || changing_password?))
  end

  def changing_password?
    !!!skip_existing_password && (persisted? && password_digest_changed?)
  end

  def changing_password_or_temporary_password?
    changing_password? || temporary_password?
  end
end
