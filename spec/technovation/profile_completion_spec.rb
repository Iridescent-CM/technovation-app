require "rails_helper"

RSpec.describe ProfileCompletion do
  it "completes prerequisites" do
    mentor = FactoryGirl.create(:mentor)
    mentor.reload.update_attributes(pre_survey_completed_at: Time.current)
    mentor.create_consent_waiver!(electronic_signature: "h")

    mentor.mentor_profile.update_attributes(bio: nil)

    CompletionSteps.new(mentor).each { }
    step = ProfileCompletion.step("build_profile")
    expect(step.completion_status).to eq("ready")
  end
end
