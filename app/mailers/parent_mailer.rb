class ParentMailer < ApplicationMailer
  def consent_notice(email, name, token)
    @name = name
    @url = new_parental_consent_url(token: token)
    mail to: email
  end

  def confirm_consent_finished(consent)
    return unless consent.student.parent_guardian_email
    @name = consent.student.parent_guardian_name
    @student_name = consent.student.full_name
    @signature = consent.electronic_signature
    @signed_date = consent.created_at.strftime("%B %e, %Y")

    mail to: consent.student.parent_guardian_email
  end
end
