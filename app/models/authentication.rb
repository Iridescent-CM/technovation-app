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

  def self.authenticated?(cookies)
    exists?(auth_token: cookies.fetch(:auth_token) { "" })
  end

  def self.authenticate_judge(cookies, callbacks = {})
    default_callbacks = { failure: -> { } }.merge(callbacks)
    current_judge(cookies).authenticated? || default_callbacks.fetch(:failure).call
  end

  def self.authenticate_admin(cookies, callbacks = {})
    default_callbacks = { failure: -> { } }.merge(callbacks)
    current_admin(cookies).authenticated? || default_callbacks.fetch(:failure).call
  end

  def self.current_judge(cookies)
    auth = find_by(auth_token: cookies.fetch(:auth_token) { "" })

    if !!auth
      auth.judge_role
    else
      NoJudgeFound.new
    end
  end

  def self.current_admin(cookies)
    auth = find_by(auth_token: cookies.fetch(:auth_token) { "" })

    if !!auth && !!auth.admin_role
      auth.admin_role
    else
      NoAdminFound.new
    end
  end

  class NoAuthFound; def authenticated?; false; end; end
  class NoJudgeFound < NoAuthFound; end
  class NoAdminFound < NoAuthFound; end
end
