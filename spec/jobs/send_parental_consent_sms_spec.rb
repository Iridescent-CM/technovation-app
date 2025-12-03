require "rails_helper"

RSpec.describe SendChapterAffiliationAgreementJob do
  let(:student_profile) {instance_double(StudentProfile, id: 123)}

  before do
    allow(StudentProfile).to receive(:find).with(student_profile.id).and_return(student_profile)
  end

  it "calls the Twilio service that will send the parental consent SMS" do
    expect(Twilio::ApiClient).to receive_message_chain(:new, :send_parental_consent_sms)
      .with(student_profile: student_profile)

    SendParentalConsentSmsJob.perform_now(profile_id: student_profile.id)
  end
end
