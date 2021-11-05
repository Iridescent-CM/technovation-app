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

  def confirm_parental_consent_finished(student_profile)
    return if student_profile.parent_guardian_email.blank?

    @student_profile = student_profile
    @parental_consent = student_profile.parental_consent

    I18n.with_locale(@student_profile.account.locale) do
      mail to: @student_profile.parent_guardian_email
    end
  end

  def confirm_media_consent_finished(student_profile)
    return if student_profile.parent_guardian_email.blank?

    @student_profile = student_profile
    @media_consent = student_profile.media_consent

    I18n.with_locale(@student_profile.account.locale) do
      mail to: @student_profile.parent_guardian_email
    end
  end

  def thank_you(student_profile)
    return if student_profile.parent_guardian_email.blank?

    @student_profile = student_profile
    @technovation_url = "http://technovationchallenge.org/about/"
    @newsletter_url = "https://confirmsubscription.com/h/d/C9D08C6FF3FA972C"

    I18n.with_locale(@student_profile.account.locale) do
      mail to: @student_profile.parent_guardian_email
    end
  end
end
