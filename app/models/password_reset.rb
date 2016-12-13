class PasswordReset
  include ActiveModel::Model

  attr_accessor :email

  validates :email, exists: true

  def perform
    account = Account.where("lower(email) = ?", email.downcase).first
    account.enable_password_reset!
    AccountMailer.password_reset(account.id).deliver_later
  end
end
