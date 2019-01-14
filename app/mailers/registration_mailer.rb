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

  def admin_permission(user_invitation_id)
    invitation = UserInvitation.find(user_invitation_id)

    if token = invitation.admin_permission_token
      @url = send(
        "#{invitation.profile_type}_signup_url",
        admin_permission_token: token
      )

      mail to: invitation.email,
           subject: t("registration_mailer.admin_permission.subject",
                      season_year: Season.current.year) do |f|
        f.html { render :confirm_email }
      end
    else
      raise AdminPermissionTokenNotPresent,
        "UserInvitation ID: #{invitation.id}"
    end
  end

  def welcome_mentor(account_id)
    account = Account.joins(:mentor_profile).find(account_id)

    @first_name = account.first_name

    @orientation_url =
      "https://infograph.venngage.com/publish/02844b99-420b-4016-8c13-1426fc29fbe7"

    @timeline_url =
      "https://infograph.venngage.com/publish/e02d29e0-28a3-4be2-b41f-3d57c475a1fe"

    @root_url = mentor_dashboard_url(mailer_token: account.mailer_token)

    @ebook_url =
      "https://iridescentlearning.atavist.com/technovation-mentor-training"

    @slack_url =
      "https://join.slack.com/t/technovationmentors/shared_invite/" +
      "enQtMzE1MzIwMjAxNzY2LTRjMjlmMzcwYTkzNDFmN2ViOWIwMjgzNjllZGVjMjRhNTBiZTExMDQ0ZGZhODE1NzUyN2ZiZDFlZDUwMzRmNjQ"

    @season_year = Season.current.year

    @consent_url = new_consent_waiver_url(mailer_token: account.mailer_token)

    @background_check_url = new_mentor_background_check_url(mailer_token: account.mailer_token)

    I18n.with_locale(account.locale) do
      mail to: account.email,
        subject: t("registration_mailer.welcome_mentor.subject",
                   season_year: Season.current.year)
    end
  end

  def welcome_student(student)
    @season_submission_deadline = Season.submission_deadline
    @season_year = Season.current.year
    @root_url = root_url(mailer_token: student.mailer_token)
    @dashboard_url = student_dashboard_url(mailer_token: student.mailer_token)
    @safety_url = "http://iridescentlearning.org/internet-safety/"
    @timeline_url =
      "https://infograph.venngage.com/publish/e02d29e0-28a3-4be2-b41f-3d57c475a1fe"
    @faq_url = "https://iridescentsupport.zendesk.com/hc/en-us/categories/115000091348-Technovation"

    I18n.with_locale(student.locale) do
      mail to: student.email,
        subject: t("registration_mailer.welcome_student.subject",
                   season_year: @season_year)
    end
  end
end
