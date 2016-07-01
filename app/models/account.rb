class Account < ActiveRecord::Base
  attr_accessor :existing_password

  before_validation :generate_auth_token, on: :create

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, :password_confirmation, presence: { on: :create }
  validates :existing_password, valid_password: true,
    if: :changes_require_password?

  validates :date_of_birth, :first_name, :last_name, :city, :region, :country,
    presence: true

  def self.has_token?(token)
    exists?(auth_token: token)
  end

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
    [city, region, Country[country].name].join(', ')
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

  private
  def generate_auth_token
    GenerateToken.(self, :auth_token)
  end

  def changes_require_password?
    persisted? && (email_changed? || password_digest_changed?)
  end

  class NoAuthFound
    def authenticated?
      false
    end
  end
end
