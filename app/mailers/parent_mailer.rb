class ParentMailer < ApplicationMailer
  def consent_notice(profile)
    @name = profile.parent_guardian_name

    if token = profile.account.consent_token
      @url = new_parental_consent_url(token: token)

      I18n.with_locale(profile.account.locale) do
        mail to: profile.parent_guardian_email
      end
    else
      raise TokenNotPresent, "Account ID: #{profile.account_id}"
    end
  end

  def confirm_consent_finished(consent)
    return unless consent.student_profile.parent_guardian_email

    @name = consent.student_profile.parent_guardian_name
    @student_name = consent.student_profile_full_name
    @signature = consent.electronic_signature
    @signed_date = consent.created_at.strftime("%B %e, %Y")

    I18n.with_locale(consent.student_profile_locale) do
      mail to: consent.student_profile.parent_guardian_email
    end
  end
end
