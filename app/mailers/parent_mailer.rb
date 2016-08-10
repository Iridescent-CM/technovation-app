class ParentMailer < ApplicationMailer
  def consent_notice(email, token)
    @url = new_parental_consent_url(token: token)
    mail to: email
  end
end
