class Authentication < ActiveRecord::Base
  has_secure_password
  has_one :user
  has_many :roles, through: :user
end
