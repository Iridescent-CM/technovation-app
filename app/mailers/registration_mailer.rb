class RegistrationMailer < ApplicationMailer
  def confirm_email(signup_attempt)
    @url = new_signup_attempt_confirmation_url(token: signup_attempt.activation_token)

    mail to: signup_attempt.email,
         subject: t("registration_mailer.confirm_email.subject", season_year: Season.current.year)
  end

  def welcome_mentor(mentor)
    @first_name = mentor.first_name
    @infographic_url = "https://infograph.venngage.com/infograph/publish/02844b99-420b-4016-8c13-1426fc29fbe7"
    @edit_account_url = edit_mentor_account_url
    @root_url = root_url

    mail to: mentor.email,
         from: "Monica Gregg <monica@technovationchallenge.org>",
         subject: t("registration_mailer.welcome_mentor.subject", season_year: Season.current.year)
  end

  def welcome_student(student)
    @season_year = Season.current.year
    @signin_url = signin_url
    @root_url = root_url
    @dashboard_url = student_dashboard_url
    @safety_url = "http://iridescentlearning.org/internet-safety/"

    mail to: student.email,
         subject: t("registration_mailer.welcome_student.subject", season_year: @season_year)
  end

  def welcome_made_with_code_student(student)
    @dashboard_url = student_dashboard_url
    @safety_url = "http://iridescentlearning.org/internet-safety/"
    @lesson_url = "http://www.technovationchallenge.org/curriculum/MadeWithCodePrimer"
    @root_url = root_url
    @root_host = ENV.fetch("HOST_DOMAIN")

    mail to: student.email,
         subject: t("registration_mailer.welcome_student.subject", season_year: Season.current.year)
  end
end
