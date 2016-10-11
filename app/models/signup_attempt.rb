class SignupAttempt < ActiveRecord::Base
  attr_accessor :prevent_email

  enum status: %i{pending active registered}
  belongs_to :account

  validates :email, presence: true, email: true

  before_create -> { GenerateToken.(self, :activation_token) }

  before_save -> {
    if status_changed? and active?
      GenerateToken.(self, :signup_token)
    end
  }

  after_commit -> {
    unless prevent_email or email_exists? or active?
      RegistrationMailer.confirm_email(self).deliver_later
    end
  }, on: [:create, :update]

  def email_exists?
    Account.where("lower(email) = ?", (email || "").strip.downcase).any?
  end
end
