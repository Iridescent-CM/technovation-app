require "spec_helper"
require "./config/initializers/checkr"
require "./app/technovation/background_check/candidate"

RSpec.describe BackgroundCheck::Candidate do
  it "sets the request_path to /v1/candidates" do
    expect(BackgroundCheck::Candidate.request_path).to eq("/v1/candidates")
  end

  it "submits a valid candidate" do
    pending
    candidate = BackgroundCheck::Candidate.new({
      first_name: "Test",
      middle_name: "Ing.",
      last_name: "Candidate",
      email: "test@test.com",
      phone: 5175556975,
      zipcode: 60622,
      dob: "1983-06-01",
      ssn: "111-11-2001",
    })

    candidate.submit

    expect(candidate.id).not_to be_nil
  end
end
