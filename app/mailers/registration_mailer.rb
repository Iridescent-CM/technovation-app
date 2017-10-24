class RegistrationMailer < ApplicationMailer
  def confirm_email(signup_attempt)
    if token = signup_attempt.activation_token
      @url = new_signup_attempt_confirmation_url(token: token)

      headers['X-Mailgun-Campaign-Id'] = 'tqylf'

      mail to: signup_attempt.email,
        subject: t("registration_mailer.confirm_email.subject",
                   season_year: Season.current.year)
    else
      raise TokenNotPresent, "SignupAttempt ID: #{signup_attempt.id}"
    end
  end

  def admin_permission(signup_attempt_id)
    signup_attempt = SignupAttempt.find(signup_attempt_id)

    if token = signup_attempt.admin_permission_token
      @url = signup_url(admin_permission_token: token)

      mail to: signup_attempt.email,
           subject: t("registration_mailer.admin_permission.subject",
                      season_year: Season.current.year) do |f|
        f.html { render :confirm_email }
      end
    else
      raise AdminPermissionTokenNotPresent, "SignupAttempt ID: #{signup_attempt.id}"
    end
  end

  def welcome_mentor(account_id)
    account = Account.joins(:mentor_profile).find(account_id)

    @first_name = account.first_name

    @orientation_url =
      "https://infograph.venngage.com/publish/02844b99-420b-4016-8c13-1426fc29fbe7"

    @timeline_url =
      "https://infograph.venngage.com/publish/af15f1ad-c6a5-4dc2-b577-29d3c1951f12"

    @root_url = mentor_dashboard_url(mailer_token: account.mailer_token)

    @ebook_url =
      "https://iridescentlearning.atavist.com/technovation-mentor-training"

    @season_year = Season.current.year

    I18n.with_locale(account.locale) do
      mail to: account.email,
        from: "Monica Gragg <monica@technovationchallenge.org>",
        subject: t("registration_mailer.welcome_mentor.subject",
                   season_year: Season.current.year)
    end
  end

  def welcome_student(student)
    @season_year = Season.current.year
    @root_url = root_url(mailer_token: student.mailer_token)
    @dashboard_url = student_dashboard_url(mailer_token: student.mailer_token)
    @safety_url = "http://iridescentlearning.org/internet-safety/"
    @timeline_url =
      "https://infograph.venngage.com/publish/af15f1ad-c6a5-4dc2-b577-29d3c1951f12"

    I18n.with_locale(student.locale) do
      mail to: student.email,
        subject: t("registration_mailer.welcome_student.subject",
                   season_year: @season_year)
    end
  end
end
