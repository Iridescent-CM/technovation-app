class ParentMailer < ApplicationMailer
  def consent_notice(profile_id)
    profile = StudentProfile.find(profile_id)
    @name = profile.parent_guardian_name
    @student_name = profile.full_name

    if token = profile.account.consent_token
      @url = edit_parental_consent_url(token: token)
      @dashboard_url = student_dashboard_url(anchor: "/parental-consent")

      I18n.with_locale(profile.account.locale) do
        mail to: profile.parent_guardian_email
      end
    else
      raise TokenNotPresent, "Account ID: #{profile.account_id}"
    end
  end

  def confirm_consent_finished(consent_id)
    consent = ParentalConsent.find(consent_id)
    return unless consent.student_profile.parent_guardian_email

    @name = consent.student_profile.parent_guardian_name
    @student_name = consent.student_profile_full_name
    @signature = consent.electronic_signature
    @signed_date = consent.updated_at.strftime("%B %e, %Y")

    I18n.with_locale(consent.student_profile_locale) do
      mail to: consent.student_profile.parent_guardian_email
    end
  end

  def thank_you(consent_id)
    profile = ParentalConsent.find(consent_id).student_profile
    @name = profile.parent_guardian_name
    @technovation_url = "http://technovationchallenge.org/about/"
    @newsletter_url = "https://confirmsubscription.com/h/d/C9D08C6FF3FA972C"

    I18n.with_locale(profile.account.locale) do
      mail to: profile.parent_guardian_email
    end
  end
end
