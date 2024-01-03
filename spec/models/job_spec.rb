require "rails_helper"

RSpec.describe Job do
  it "stores a JSON payload" do
    owner = FactoryBot.create(:mentor, :onboarded).account

    job = Job.create!(
      owner: owner,
      payload: {custom: "field data"}
    )

    expect(job.payload).to eq({"custom" => "field data"})
  end
end
