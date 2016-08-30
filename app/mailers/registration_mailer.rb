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

    mail to: mentor.email,
         from: @contact_email
  end
end
