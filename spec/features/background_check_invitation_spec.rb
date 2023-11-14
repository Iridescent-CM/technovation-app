require "rails_helper"

RSpec.feature "background check invitation" do
  scenario "Request a background check invitation as a mentor in India", :vcr do
    mentor = FactoryBot.create(
      :mentor,
      :india,
      account: FactoryBot.create(:account, email: "engineering+factorymentor@technovation.org")
    )
    mentor.background_check.destroy

    sign_in(mentor)
    click_link "Submit Background Check"

    expect(page).to have_link("Request background check invitation")
    click_link "Request background check invitation"

    expect(mentor.reload.background_check).to be_present
  end
end
