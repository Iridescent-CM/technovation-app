require "rails_helper"

RSpec.describe BackgroundCheck::Candidate, :vcr do
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

    expect(candidate.id).not_to be_nil
  end
end
