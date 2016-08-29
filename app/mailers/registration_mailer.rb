class RegistrationMailer < ApplicationMailer
  def welcome_mentor(mentor)
    @first_name = mentor.first_name
    @contact_name = "[CONTACT NAME]"
    @contact_position = "[CONTACT POSITION]"
    @contact_email = "[CONTACT EMAIL]"
    @contact_first_name = "[CONTACT FIRST NAME]"
    @edit_account_url = edit_mentor_account_url
    @edit_bio_url = edit_mentor_account_url(anchor: "account-profile-details")

    mail to: mentor.email
  end
end
