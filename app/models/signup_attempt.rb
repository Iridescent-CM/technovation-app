class SignupAttempt < ActiveRecord::Base
  attr_accessor :prevent_email

  enum status: %i{pending active registered}
  belongs_to :account

  validates :email, presence: true, email: true

  has_secure_token :pending_token
  has_secure_token :activation_token
  has_secure_token :signup_token

  after_commit -> {
    if status_changed? and active?
      regenerate_signup_token
    end
  }, on: :update

  after_commit -> {
    unless prevent_email or email_exists? or active?
      RegistrationMailer.confirm_email(self).deliver_later
    end
  }, on: [:create, :update]

  def email_exists?
    Account.where("lower(email) = ?", (email || "").strip.downcase).any?
  end
end
