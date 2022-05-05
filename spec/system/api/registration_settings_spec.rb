require "rails_helper"

RSpec.describe "Registration Settings" do
  let(:registration_open) { true }
  let(:student_registration_open) { true }
  let(:mentor_registration_open) { true }

  before do
    allow(SeasonToggles).to receive(:registration_open?)
      .and_return(registration_open)
    allow(SeasonToggles).to receive(:student_registration_open?)
      .and_return(student_registration_open)
    allow(SeasonToggles).to receive(:mentor_registration_open?)
      .and_return(mentor_registration_open)
  end

  it "returns registration settings" do
    get api_registration_settings_path

    expect(JSON.parse(response.body)).to eq(
      {
        "isRegistrationOpen" => registration_open,
        "isStudentRegistrationOpen" => student_registration_open,
        "isMentorRegistrationOpen" => mentor_registration_open
      }
    )
  end
end
