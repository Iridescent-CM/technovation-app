class Account < ActiveRecord::Base
  attr_accessor :existing_password

  geocoded_by :address_details

  before_validation :generate_auth_token, on: :create
  after_validation :geocode, if: :address_changed?
  after_create :register_current_season

  has_secure_password

  has_many :season_registrations, as: :registerable
  has_many :seasons, through: :season_registrations

  validates :email, presence: true, uniqueness: true
  validates :password, :password_confirmation, presence: { on: :create }
  validates :existing_password, valid_password: true,
    if: :changes_require_password?

  validates :date_of_birth, :first_name, :last_name, :city, :state_province, :country,
    presence: true

  def self.find_with_token(token)
    find_by(auth_token: token) || NoAuthFound.new
  end

  def self.find_profile_with_token(token, profile)
    "#{String(profile).camelize}Account".constantize.find_by(auth_token: token) or
      AdminAccount.find_with_token(token)
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def address_details
    [city, state_province, Country[country].try(:name)].join(', ')
  end

  def sign_consent_form!
    update_attributes(consent_signed_at: Time.current)
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

  private
  def generate_auth_token
    GenerateToken.(self, :auth_token)
  end

  def register_current_season
    RegisterToCurrentSeasonJob.perform_later(self)
  end

  def changes_require_password?
    persisted? && (email_changed? || password_digest_changed?)
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
end
