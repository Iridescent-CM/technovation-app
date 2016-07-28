require "rails_helper"

RSpec.describe ProfileCompletion do
  it "completes prerequisites" do
    mentor = FactoryGirl.create(:mentor)
    mentor.update_attributes(pre_survey_completed_at: Time.current)
    mentor.create_consent_waiver!(consent_confirmation: 1,
                                  electronic_signature: "h")

    CompletionSteps.new(mentor).each { }
    step = ProfileCompletion.step("build_profile")
    expect(step.completion_status).to eq("ready")
  end
end
