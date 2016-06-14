class User < ActiveRecord::Base
  belongs_to :authentication

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  delegate :email, :password, to: :authentication, prefix: false

  validates :authentication_id, presence: true
end
