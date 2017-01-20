class AccountMailer < ApplicationMailer
  def password_reset(account_id)
    account = Account.find(account_id)
    @first_name = account.first_name

    token = account.password_reset_token

    if not token.blank?
      @url = new_password_url(token: token)
      I18n.with_locale(account.locale) do
        mail to: account.email
      end
    else
      raise TokenNotPresent, "Account ID: #{account.id}"
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
