class AdminMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.invite_new_admin.subject
  #
  def invite_new_admin(admin)
    @admin = admin
    @url = admin_signup_url(token: admin.admin_invitation_token)

    mail to: admin.email,
      subject: "Create your Technovation Admin password"
  end
end
