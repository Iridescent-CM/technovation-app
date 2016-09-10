class RegistrationMailer < ApplicationMailer
  def welcome_mentor(mentor)
    @first_name = mentor.first_name
    @contact_name = "Allie Glotfelty"
    @contact_position = "Events and Engagement Director"
    @contact_email = "allie@technovationchallenge.org"
    @contact_first_name = "Allie"
    @edit_account_url = edit_mentor_account_url
    @upload_photo_url = mentor_account_url
    @edit_bio_url = edit_mentor_account_url(anchor: "account-profile-details")

    mail to: mentor.email, from: @contact_email
  end

  def welcome_student(student)
    @season_year = Season.current.year
    @signin_url = signin_url
    @root_url = root_url

    mail to: student.email,
         subject: t("registration_mailer.welcome_student.subject", season_year: @season_year)
  end
end
