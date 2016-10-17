class ParentMailer < ApplicationMailer
  def consent_notice(profile)
    @name = profile.parent_guardian_name
    @url = new_parental_consent_url(token: profile.account.consent_token)

    I18n.with_locale(profile.account.locale) do
      mail to: profile.parent_guardian_email
    end
  end

  def confirm_consent_finished(consent)
    return unless consent.student.parent_guardian_email
    @name = consent.student.parent_guardian_name
    @student_name = consent.student.full_name
    @signature = consent.electronic_signature
    @signed_date = consent.created_at.strftime("%B %e, %Y")

    I18n.with_locale(consent.student.locale) do
      mail to: consent.student.parent_guardian_email
    end
  end
end
