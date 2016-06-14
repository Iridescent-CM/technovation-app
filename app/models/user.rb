class User < ActiveRecord::Base
  default_scope { includes({ user_roles: :role }, :roles, :authentication) }

  belongs_to :authentication

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  delegate :email, :password, to: :authentication, prefix: false

  validates :authentication_id, presence: true

  def judge_user_role
    user_roles.judge
  end
end
