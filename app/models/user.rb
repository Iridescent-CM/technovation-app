class User < ActiveRecord::Base
  belongs_to :authentication

  has_many :user_roles
  has_many :roles, through: :user_roles

  has_many :user_expertises
  has_many :expertises, through: :user_expertises

  delegate :email, :password, to: :authentication, prefix: false

  def add_expertise(expertise)
    expertises << expertise
  end

  def authenticated?
    true
  end
end
