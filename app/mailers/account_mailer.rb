class AccountMailer < ApplicationMailer
  def password_reset(account)
    @first_name = account.first_name
    @url = new_password_url(token: account.password_reset_token)
    mail to: account.email
  end

  def confirm_next_steps(consent)
    @name = consent.student.first_name
    @url = student_dashboard_url
    mail to: consent.student.email
  end
end
