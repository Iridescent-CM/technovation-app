class Account < ActiveRecord::Base
  include Elasticsearch::Model
  include Casting::Client
  delegate_missing_methods

  after_destroy { IndexModelJob.perform_later("delete", "Account", id) }

  index_name "#{ENV.fetch("ES_RAILS_ENV") { Rails.env }}_accounts"
  document_type 'account'
  settings index: { number_of_shards: 1, number_of_replicas: 1 }

  geocoded_by :address_details
  reverse_geocoded_by :latitude, :longitude do |account, results|
    Casting.delegating(account => ReverseGeocoder) do
      account.update_geocoding_from_results(results)
    end
  end

  attr_accessor :existing_password, :skip_existing_password, :confirm_sentence

  has_one :admin_profile, dependent: :destroy
  has_one :student_profile, dependent: :destroy
  has_one :mentor_profile, dependent: :destroy
  has_one :judge_profile, dependent: :destroy
  has_one :regional_ambassador_profile, dependent: :destroy
  has_one :signup_attempt, dependent: :destroy

  has_one :honor_code_agreement, -> { nonvoid }, dependent: :destroy
  has_one :consent_waiver, -> { nonvoid }, dependent: :destroy

  has_many :certificates
  has_many :void_honor_code_agreements,
    -> { void },
    class_name: "HonorCodeAgreement",
    dependent: :destroy
  has_many :void_consent_waivers,
    -> { void },
    class_name: "ConsentWaiver",
    dependent: :destroy

  has_one :background_check, dependent: :destroy
  accepts_nested_attributes_for :background_check

  enum referred_by: %w{Friend Colleague Article Internet Social\ media
                       Print Web\ search Teacher Parent/family Company\ email
                       Made\ With\ Code Other}

  enum gender: %w{Female Male Non-binary Prefer\ not\ to\ say}

  scope :current, -> {
    joins(season_registrations: :season)
    .where("season_registrations.status = ? AND seasons.year = ?",
           SeasonRegistration.statuses[:active],
           Season.current.year)
  }

  mount_uploader :profile_image, ImageProcessor

  has_secure_token :auth_token
  has_secure_token :consent_token
  has_secure_token :password_reset_token
  has_secure_password

  has_many :season_registrations, -> { active }, as: :registerable
  has_many :seasons, through: :season_registrations

  validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true
  validates :profile_image, verify_cached_file: true

  validates :existing_password, valid_password: true, if: :changes_require_password?
  validates :password, length: { minimum: 8, on: :create, if: :temporary_password? }
  validates :password, length: { minimum: 8, on: :update, if: :changes_require_password? }

  validates :date_of_birth, :first_name, :last_name, presence: true

  def self.find_with_token(token)
    find_by(auth_token: token) || NullAuth.new
  end

  def self.find_judge_profile_id_by_email(email)
    find_by(email: email).judge_profile.id
  end

  def self.find_profile_with_token(token, profile)
    "#{String(profile).camelize}Account".constantize.find_by(auth_token: token) or
      NullAuth.new
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

  def as_indexed_json(options = {})
    as_json(only: %w{id email first_name last_name})
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def address_details
    [city, state_province, Country[country].try(:name)].reject(&:blank?).join(', ')
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

  def parental_consent
    if student_profile
      student_profile.parental_consent
    end
  end

  def division
    Division.for(student_profile).name.humanize
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

  def current_season_registration
    season_registrations.joins(:season)
      .where("seasons.year = ?", Season.current.year)
      .last
  end

  def temporary_password?
    new_record? and
      SignupAttempt.temporary_password.where("lower(email) = ?", email.downcase).any?
  end

  def type_name(module_name = nil)
    if module_name and module_name === "judge"
      "judge"
    elsif mentor_profile.present?
      "mentor"
    elsif regional_ambassador_profile.present?
      "regional_ambassador"
    elsif student_profile.present?
      "student"
    elsif judge_profile.present?
      "judge"
    elsif admin_profile.present?
      "admin"
    else
      "application"
    end
  end

  def honor_code_signed?
    honor_code_agreement.present?
  end

  def consent_signed?
    consent_waiver.present?
  end

  def consent_waiver
    super || NullConsentWaiver.new
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
      t = Struct.new(:current)
      def t.current; Team.none; end
      t
    end
  end

  def team_region_division_names
    team_keys = teams.current.map(&:cache_key).join('/')
    Rails.cache.fetch("#{team_keys}/team_region_division_names") do
      teams.current.map {|t| t.region_division_name }.uniq
    end
  end

  private
  def changes_require_password?
    !!!skip_existing_password &&
      (persisted? && (email_changed? || password_digest_changed?))
  end
end
