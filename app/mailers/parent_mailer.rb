class ParentMailer < ApplicationMailer
  def consent_notice(profile)
    @url = new_parental_consent_url(token: profile.account.consent_token)
    mail to: profile.parent_guardian_email
  end
end
