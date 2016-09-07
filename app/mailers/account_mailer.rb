class AccountMailer < ApplicationMailer

  def password_reset(account)
    @first_name = account.first_name
    @url = new_password_url(token: account.password_reset_token)
    mail to: account.email
  end
end
