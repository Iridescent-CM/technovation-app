require "rails_helper"

RSpec.describe "Registration Settings" do
  let(:student_registration_open) { true }
  let(:mentor_registration_open) { true }
  let(:judge_registration_open) { true }

  before do
    allow(SeasonToggles).to receive(:student_registration_open?)
      .and_return(student_registration_open)
    allow(SeasonToggles).to receive(:mentor_registration_open?)
      .and_return(mentor_registration_open)
    allow(SeasonToggles).to receive(:judge_registration_open?)
      .and_return(judge_registration_open)
  end

  it "returns registration settings" do
    get api_registration_settings_path

    expect(JSON.parse(response.body)).to eq(
      {
        "isStudentRegistrationOpen" => student_registration_open,
        "isMentorRegistrationOpen" => mentor_registration_open,
        "isJudgeRegistrationOpen" => judge_registration_open
      }
    )
  end
end
