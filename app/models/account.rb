class Account < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  after_save    { IndexAccountJob.perform_later("index", id) }
  after_destroy { IndexAccountJob.perform_later("delete", id) }

  define_method(:as_indexed_json) do |options = {}|
    as_json(only: %w{id email first_name last_name})
  end

  index_name "#{Rails.env}_accounts"
  document_type 'account'
  settings index: { number_of_shards: 1, number_of_replicas: 1 }

  attr_accessor :existing_password, :skip_existing_password, :geocoded

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

  geocoded_by :geocoded
  reverse_geocoded_by :latitude, :longitude do |account, results|
    if geo = results.first
      account.city = geo.city
      account.state_province = geo.state_code
      country = Country.find_country_by_name(geo.country_code) ||
                  Country.find_country_by_alpha3(geo.country_code) ||
                    Country.find_country_by_alpha2(geo.country_code)
      account.country = country.alpha2
    end
  end

  has_secure_token :auth_token
  has_secure_token :consent_token
  has_secure_token :password_reset_token
  has_secure_password

  # Fallback incase Typeahead doesn't work or isn't used
  before_validation :geocode, if: ->(a) {
    !a.geocoded.blank? and a.geocoded != address_details
  }

  before_validation :reverse_geocode, if: ->(a) { a.latitude_changed? }

  after_validation :update_email_list, on: :update
  after_commit -> { AttachSignupAttemptJob.perform_later(self) }, on: :create

  has_many :season_registrations, -> { active }, as: :registerable
  has_many :seasons, through: :season_registrations

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :geocoded, presence: true, if: ->(a) { a.latitude.blank? }
  validates :profile_image, verify_cached_file: true

  validates :existing_password, valid_password: true, if: :changes_require_password?
  validates :password, length: { minimum: 8, on: :create, if: :temporary_password? }

  validates :date_of_birth, :first_name, :last_name, :country, presence: true

  def self.find_with_token(token)
    find_by(auth_token: token) || NoAuthFound.new
  end

  def self.find_profile_with_token(token, profile)
    "#{String(profile).camelize}Account".constantize.find_by(auth_token: token) or
      NoAuthFound.new
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
    Date.today.year - 20
  end

  def enable_password_reset!
    regenerate_password_reset_token
    update_column(:password_reset_token_sent_at, Time.current)
  end

  def get_school_company_name
    if respond_to?(:school_name)
      school_name
    elsif respond_to?(:company_name)
      company_name
    elsif respond_to?(:school_company_name)
      school_company_name
    elsif respond_to?(:organization_company_name)
      organization_company_name
    end
  end

  def division
    Division.for(self).name.humanize
  end

  def teams
    teams = Struct.new(:current)
    def teams.current; []; end
    teams
  end

  def age
    now = Time.current.utc.to_date

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

  private
  def update_email_list
    if first_name_changed? or last_name_changed? or email_changed?
      UpdateEmailListJob.perform_later(
        email_was, email, full_name, "#{type_name.upcase}_LIST_ID"
      )
    end
  end

  def changes_require_password?
    !!!skip_existing_password &&
      (persisted? && (email_changed? || password_digest_changed?))
  end

  def address_changed?
    city_changed? or state_province_changed? or country_changed?
  end

  class NoAuthFound
    def authenticated?
      false
    end

    def type_name
      'application'
    end

    def locale
      I18n.default_locale
    end
  end
end
