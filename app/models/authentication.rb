class Authentication < ActiveRecord::Base
  attr_accessor :existing_password, :expertise_ids

  has_secure_password

  has_many :authentication_roles, dependent: :destroy
  has_many :roles, through: :authentication_roles

  has_one :judge_role,
    -> { where(roles: { name: Role.names[:judge] }) },
    class_name: "AuthenticationRole"

  has_one :admin_role,
    -> { where(roles: { name: Role.names[:admin] }) },
    class_name: "AuthenticationRole"

  validates :email, presence: true, uniqueness: true
  validate :existing_password, :require_valid_password, if: :changes_require_password?

  def self.has_token?(token)
    exists?(auth_token: token)
  end

  def self.find_with_token_and_roles(token, roles)
    roles.map { |role|
      find_with_token(token).send("#{role}_role")
    }.compact.first || NoRoleFound.new(*roles)
  end

  private
  def changes_require_password?
    (!!changes[:email] && !!changes[:email][0]) ||
      (!!changes[:password_digest] && !!changes[:password_digest][0])
  end

  def require_valid_password
    unless changes_authenticated?
      errors.add(:existing_password, I18n.translate(
        'models.authentication.errors.existing_password.invalid'
      ))
    end
  end

  def changes_authenticated?
    if !!email_was
      self.class.find_by(email: email_was).authenticate(existing_password)
    else
      authenticate(existing_password)
    end
  end

  def self.find_with_token(token)
    find_by(auth_token: token) || NoAuthFound.new
  end

  class NoAuthFound
    def judge_role; NoRoleFound.new(:judge); end
    def admin_role; NoRoleFound.new(:admin); end
  end

  class NoRoleFound
    def initialize(*attempted_roles)
      @attempted_roles = attempted_roles
    end

    def authenticated?
      false
    end
  end
end
