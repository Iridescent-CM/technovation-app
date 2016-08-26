require "spec_helper"
require "./config/initializers/checkr"
require "./app/technovation/background_check/candidate"
require "./app/technovation/background_check/report"

RSpec.describe BackgroundCheck::Report, :vcr do
  it "sets the request_path to /v1/reports" do
    expect(BackgroundCheck::Report.request_path).to eq("/v1/reports")
  end

  it "submits a valid candidate" do
    candidate = BackgroundCheck::Candidate.new({
      first_name: "Test",
      middle_name: "Ing.",
      last_name: "Candidate",
      email: "test@test.com",
      phone: 5175556975,
      zipcode: 90401,
      dob: "1983-06-01",
      ssn: "111-11-2001",
      driver_liscence_number: "F1112001",
      driver_license_state: "CA",
    })

    candidate.submit

    report = BackgroundCheck::Report.new(candidate)

    report.submit

    expect(report.id).not_to be_nil
  end
end
