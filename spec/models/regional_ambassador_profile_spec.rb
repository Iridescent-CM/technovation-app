require "rails_helper"

RSpec.describe RegionalAmbassadorProfile do
  it "emails on decline" do
    ambassador = FactoryBot.create(:regional_ambassador)

    ambassador.declined!

    expect(ActionMailer::Base.deliveries.last.subject).to eq(
      "Regional Ambassador Request Follow-up"
    )
  end
end
