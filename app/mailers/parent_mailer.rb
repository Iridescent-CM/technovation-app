class ParentMailer < ApplicationMailer
  def consent_notice(student)
    @url = new_parental_consent_url(token: student.consent_token)
    mail to: student.parent_guardian_email
  end
end
