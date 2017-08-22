class UnconfirmedEmailAddress < ApplicationRecord
  belongs_to :account
  validates :email, presence: true, email: true
  has_secure_token :confirmation_token
end
