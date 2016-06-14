class User < ActiveRecord::Base
  default_scope { includes({ user_roles: :role }, :roles, :authentication) }

  belongs_to :authentication

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  has_one :judge_user_role,
    -> { where(roles: { name: Role.names[:judge] }) },
    class_name: "UserRole"

  delegate :email, :password, to: :authentication, prefix: false

  validates :authentication_id, presence: true
end
