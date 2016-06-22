class Authentication < ActiveRecord::Base
  PROFILE_TYPES = {
    student: 0,
    judge: 1,
    admin: 2,
  }

  attr_accessor :existing_password

  has_secure_password

  has_one :basic_profile
  has_one :admin_profile
  has_one :student_profile
  has_one :judge_profile

  validates :email, presence: true, uniqueness: true
  validates :existing_password, valid_password: true, if: :changes_require_password?

  validates_associated :basic_profile, if: ->(auth) { auth.basic_profile.present? }
  accepts_nested_attributes_for :basic_profile, reject_if: :all_blank

  validates_associated :student_profile, if: ->(auth) { auth.student_profile.present? }
  accepts_nested_attributes_for :student_profile, reject_if: :all_blank

  validates_associated :judge_profile, if: ->(auth) { auth.judge_profile.present? }
  accepts_nested_attributes_for :judge_profile, reject_if: :all_blank

  def self.has_token?(token)
    exists?(auth_token: token)
  end

  def self.find_with_token(token)
    find_by(auth_token: token) || NoAuthFound.new
  end

  def self.find_role_with_token(token, roles)
    roles.map { |role|
      find_with_token(token).send("#{role}_profile")
    }.compact.first || NoRolesFound.new(*roles)
  end

  def self.registerable_profile(value)
    PROFILE_TYPES.reject { |k, _| k == :admin }
                 .select { |_, v| v == Integer(value) }
                 .keys
                 .first
  end

  private
  def changes_require_password?
    persisted? && (email_changed? || password_digest_changed?)
  end

  class NoAuthFound
    PROFILE_TYPES.keys.each do |name|
      define_method "#{name}_profile" do
        NoRolesFound.new(name)
      end
    end
  end

  class NoRolesFound
    def initialize(*attempted_roles)
      @attempted_roles = attempted_roles
    end

    def authenticated?
      false
    end
  end
end
