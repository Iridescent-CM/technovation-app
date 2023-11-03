require "rails_helper"

RSpec.describe "Registration Settings" do
  before do
    allow(RegistrationSettingsAggregator).to receive_message_chain(:new, :call)
      .and_return(registration_settings)
  end

  let(:registration_settings) {
    instance_double("registratation_settings",
      student_registration_open?: true,
      parent_registration_open?: true,
      mentor_registration_open?: true,
      judge_registration_open?: true,
      chapter_ambassador_registration_open?: false,
      invited_registration_profile_type: "student",
      success_message: "",
      error_message: "")
  }

  it "returns registration settings" do
    get api_registration_settings_path

    expect(JSON.parse(response.body)).to eq(
      {
        "isStudentRegistrationOpen" => registration_settings.student_registration_open?,
        "isParentRegistrationOpen" => registration_settings.parent_registration_open?,
        "isMentorRegistrationOpen" => registration_settings.mentor_registration_open?,
        "isJudgeRegistrationOpen" => registration_settings.judge_registration_open?,
        "isChapterAmbassadorRegistrationOpen" => registration_settings.chapter_ambassador_registration_open?,
        "invitedRegistrationProfileType" => registration_settings.invited_registration_profile_type,
        "successMessage" => registration_settings.success_message,
        "errorMessage" => registration_settings.error_message
      }
    )
  end
end
