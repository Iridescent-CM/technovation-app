class AccountMailer < ApplicationMailer
  def confirm_changed_email(account_id)
    account = Account.find(account_id)
    token = account.unconfirmed_email_address.confirmation_token

    if token.blank?
      account.unconfirmed_email_address.regenerate_confirmation_token
      token = account.unconfirmed_email_address.confirmation_token
    end

    if !token.blank?
      @url = new_email_confirmation_url(token: token)
      I18n.with_locale(account.locale) do
        mail to: account.email
      end
    else
      raise TokenNotPresent, "Account ID: #{account_id}"
    end
  end

  def password_reset(account_id)
    account = Account.find(account_id)
    @first_name = account.first_name

    token = account.password_reset_token

    if token.blank?
      account.regenerate_password_reset_token
      token = account.password_reset_token
    end

    if !token.blank?
      @url = new_password_url(token: token)
      I18n.with_locale(account.locale) do
        mail to: account.email
      end
    else
      raise TokenNotPresent, "Account ID: #{account.id}"
    end
  end

  def confirm_next_steps(account)
    @name = account.first_name
    @url = student_dashboard_url(
      mailer_token: account.mailer_token
    )

    I18n.with_locale(account.locale) do
      mail to: account.email
    end
  end

  def background_check_clear(account)
    @name = account.first_name

    @url = send(
      "#{account.scope_name.sub(/^\w+_chapter_ambassador/, "chapter_ambassador")}_dashboard_url",
      mailer_token: account.mailer_token
    )

    I18n.with_locale(account.locale) do
      mail to: account.email
    end
  end
end
