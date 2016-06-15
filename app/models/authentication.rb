class Authentication < ActiveRecord::Base
  has_secure_password

  has_many :authentication_roles
  has_many :roles, through: :authentication_roles

  has_one :judge_role,
    -> { where(roles: { name: Role.names[:judge] }) },
    class_name: "AuthenticationRole"

  has_one :admin_role,
    -> { where(roles: { name: Role.names[:admin] }) },
    class_name: "AuthenticationRole"

  validates :email, presence: true, uniqueness: true

  def self.has_token?(token)
    exists?(auth_token: token)
  end

  def self.find_with_token_and_roles(token, roles)
    roles.map { |role|
      find_with_token(token).send("#{role}_role")
    }.compact.first || NoRoleFound.new(*roles)
  end

  private
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
