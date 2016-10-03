require "rails_helper"

RSpec.describe BackgroundCheck::Report, :vcr do
  let(:candidate) do
    BackgroundCheck::Candidate.new({
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
  end

  before { candidate.submit }

  it "gets an id from submitting" do
    report = BackgroundCheck::Report.new(candidate_id: candidate.id)
    report.submit
    expect(report.id).not_to be_nil
  end

  it "retrieves an existing report" do
    report = BackgroundCheck::Report.new(candidate_id: candidate.id)
    report.submit

    retrieved_report = BackgroundCheck::Report.retrieve(report.id)
    expect(retrieved_report.status).to eq("clear")
  end
end
