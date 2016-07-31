class AccountMailer < ApplicationMailer

  def password_reset(account)
    @url = new_password_url(token: account.password_reset_token)
    mail to: account.email
  end
end
