class SendParentalConsentSmsJob < ActiveJob::Base
  queue_as :default

  def perform(profile_id:)
    student_profile = StudentProfile.find(profile_id)

    Twilio::ApiClient.new.send_parental_consent_sms(
      student_profile: student_profile
    )
  end
end
