class ParentMailer < ApplicationMailer
  def consent_notice(student_account)
    @url = new_parental_consent_url(token: student_account.consent_token)
    mail to: student_account.parent_guardian_email
  end
end
