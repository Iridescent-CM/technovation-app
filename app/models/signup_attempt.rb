class SignupAttempt < ActiveRecord::Base
  enum status: %i{pending active registered}
  belongs_to :account

  validates :email, presence: true

  before_create -> { GenerateToken.(self, :activation_token) }
  after_save -> { RegistrationMailer.confirm_email(self).deliver_later }

  def email_exists?
    Account.where("lower(email) = ?", email.strip.downcase).any?
  end
end
