class PasswordReset
  include ActiveModel::Model

  attr_accessor :email

  validates :email, exists: true

  def perform
    account = Account.find_by(email: email)
    account.enable_password_reset!
    AccountMailer.password_reset(account).deliver_later
  end
end
