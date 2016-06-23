class Authentication < ActiveRecord::Base
  PROFILE_TYPES = {
    student: 0,
    judge: 1,
    admin: 2,
  }

  attr_accessor :existing_password

  has_secure_password

  has_one :basic_profile
  has_one :student_profile
  has_one :judge_profile
  has_one :admin_profile

  accepts_nested_attributes_for :basic_profile, reject_if: :all_blank
  accepts_nested_attributes_for :student_profile, reject_if: :all_blank
  accepts_nested_attributes_for :judge_profile, reject_if: :all_blank

  validates :email, presence: true, uniqueness: true
  validates :password, :password_confirmation, presence: true
  validates :existing_password, valid_password: true,
    if: :changes_require_password?

  validates_associated :basic_profile, unless: :basic_profile_blank?
  validates_associated :student_profile, unless: :student_profile_blank?
  validates_associated :judge_profile, unless: :judge_profile_blank?

  def self.has_token?(token)
    exists?(auth_token: token)
  end

  def self.find_with_token(token)
    find_by(auth_token: token) || NoAuthFound.new
  end

  def self.find_role_with_token(token, profiles)
    profiles.map { |profile|
      find_with_token(token).send("#{profile}_profile")
    }.compact.first || NoProfilesFound.new(*profiles)
  end

  def self.registerable_profile(value)
    registerable_profiles.select { |_, v| v == Integer(value) }.keys.first
  end

  def self.registerable_profiles
    PROFILE_TYPES.reject { |k, _| k == :admin }
  end

  private
  def changes_require_password?
    persisted? && (email_changed? || password_digest_changed?)
  end

  def basic_profile_blank?
    all_attributes_blank?(basic_profile)
  end

  def student_profile_blank?
    all_attributes_blank?(student_profile)
  end

  def judge_profile_blank?
    all_attributes_blank?(judge_profile)
  end

  def all_attributes_blank?(profile)
    profile.present? and profile.attributes.values.all?(&:blank?)
  end

  class NoAuthFound
    PROFILE_TYPES.keys.each do |name|
      define_method "#{name}_profile" do
        NoProfilesFound.new(name)
      end
    end
  end

  class NoProfilesFound
    def initialize(*attempted_profiles)
      @attempted_profiles = attempted_profiles
    end

    def authenticated?
      false
    end
  end
end
