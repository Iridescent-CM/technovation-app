class Account < ActiveRecord::Base
  attr_accessor :existing_password, :skip_existing_password, :geocoded

  enum referred_by: %w{Friend Colleague Article Internet Social\ media
                       Print Web\ search Teacher Parent/family Company\ email
                       Made\ With\ Code Other}

  enum gender: %w{Female Male Non-binary Prefer\ not\ to\ say}

  mount_uploader :profile_image, ImageUploader

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

  before_validation :generate_tokens, on: :create

  # Fallback incase Typeahead doesn't work or isn't used
  before_validation :geocode, if: ->(a) { !a.geocoded.blank? and a.geocoded != address_details }
  before_validation :reverse_geocode, if: ->(a) { a.latitude_changed? }

  after_validation :update_email_list, on: :update

  has_secure_password

  has_many :season_registrations, as: :registerable
  has_many :seasons, through: :season_registrations

  has_one :consent_waiver, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  validates :password, :password_confirmation, presence: { on: :create }
  validates :password, length: { minimum: 8, on: :create }
  validates :existing_password, valid_password: true, if: :changes_require_password?

  validates :date_of_birth, :first_name, :last_name, :city, :country, presence: true

  delegate :electronic_signature,
           :signed_at,
    to: :consent_waiver,
    prefix: true

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

  def authenticated?
    true
  end

  def admin?
    false
  end

  def type_name
    type.underscore.sub('_account', '')
  end

  def consent_signed?
    consent_waiver.present?
  end

  def complete_pre_program_survey!
    update_attributes(pre_survey_completed_at: Time.current)
  end

  def pre_survey_completed?
    !!pre_survey_completed_at
  end

  def oldest_birth_year
    Date.today.year - 80
  end

  def youngest_birth_year
    Date.today.year - 20
  end

  def enable_password_reset!
    GenerateToken.(self, :password_reset_token)
    update_attributes(password_reset_token_sent_at: Time.current)
  end

  def consent_waiver
    super || NullConsentWaiver.new
  end

  def enable_searchability
    # Implemented by MentorAccount
  end

  def after_registration
    # Implemented by StudentAccount, MentorAccount
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
    []
  end

  private
  def update_email_list
    if first_name_changed? or last_name_changed? or email_changed?
      UpdateEmailListJob.perform_later(email_was, email, full_name, list_id)
    end
  end

  def list_id
    ENV.fetch("#{type_name.upcase}_LIST_ID")
  end

  def generate_tokens
    GenerateToken.(self, :auth_token)
    GenerateToken.(self, :consent_token)
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
  end

  class NullConsentWaiver
    def status
      "Not signed"
    end

    def present?
      false
    end
  end
end
