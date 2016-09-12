class RegistrationMailer < ApplicationMailer
  def welcome_mentor(mentor)
    @first_name = mentor.first_name
    @infographic_url = "https://infograph.venngage.com/infograph/publish/02844b99-420b-4016-8c13-1426fc29fbe7"
    @edit_account_url = edit_mentor_account_url
    @training_url = "http://www.iridescentuniversity.org/lms/"
    @slack_url = "https://technovationmentors.slack.com/signup"
    @root_url = root_url

    mail to: mentor.email,
         from: "<Monica Gregg> monica@technovationchallenge.org",
         subject: t("registration_mailer.welcome_mentor.subject", season_year: Season.current.year)
  end

  def welcome_student(student)
    @season_year = Season.current.year
    @signin_url = signin_url
    @root_url = root_url

    mail to: student.email,
         subject: t("registration_mailer.welcome_student.subject", season_year: @season_year)
  end
end
