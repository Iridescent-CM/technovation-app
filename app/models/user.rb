class User < ActiveRecord::Base
  default_scope { includes({ user_roles: :role }, :roles, :authentication) }

  belongs_to :authentication

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  delegate :email, :password, to: :authentication, prefix: false

  validates :authentication_id, presence: true

  def submission_ids
    !!judge_role && judge_role.submission_ids
  end

  def judge_role_id
    !!judge_role && judge_role.id
  end

  def judge_role
    user_roles.judge
  end
end
