class AccountMailer < ApplicationMailer
  def password_reset(account)
    @first_name = account.first_name
    @url = new_password_url(token: account.password_reset_token)

    I18n.with_locale(account.locale) do
      mail to: account.email
    end
  end

  def confirm_next_steps(consent)
    @name = consent.student_profile_first_name
    @url = student_dashboard_url

    I18n.with_locale(consent.student_profile_locale) do
      mail to: consent.student_profile_email
    end
  end

  def background_check_clear(account)
    @name = account.first_name
    @url = send("#{account.type_name}_dashboard_url")

    I18n.with_locale(account.locale) do
      mail to: account.email
    end
  end
end
