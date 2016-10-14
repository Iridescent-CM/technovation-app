class SignupAttempt < ActiveRecord::Base
  has_secure_password

  enum status: %i{pending active registered temporary_password}
  belongs_to :account

  validates :email, presence: true, email: true
  validates :password, length: { minimum: 8, on: :create }

  has_secure_token :pending_token
  has_secure_token :activation_token
  has_secure_token :signup_token

  after_commit -> {
    if status_changed? and active?
      regenerate_signup_token
    end
  }, on: :update

  after_commit -> {
    if pending?
      RegistrationMailer.confirm_email(self).deliver_later
    end
  }, on: [:create, :update]
end
