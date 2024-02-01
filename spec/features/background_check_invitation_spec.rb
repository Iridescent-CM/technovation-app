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

  scenario "Request a background check invitation as a chapter ambassador", :vcr do
    chapter_ambassador = FactoryBot.create(
      :chapter_ambassador,
      :approved,
      :geocoded,
      account: FactoryBot.create(:account, email: "engineering+factorycha@technovation.org")
    )
    chapter_ambassador.background_check.destroy

    sign_in(chapter_ambassador)

    click_link "Background Check"
    click_link "Submit Background Check"

    expect(page).to have_link("Request background check invitation")
    click_link "Request background check invitation"

    expect(chapter_ambassador.reload.background_check).to be_present
    expect(chapter_ambassador.background_check.internal_invitation_status).to eq("invitation_sent")
  end

  scenario "Chapter ambassadors will see an error message if their last name is less than 2 characters when trying to request a background check invitation" do
    chapter_ambassador = FactoryBot.create(
      :chapter_ambassador,
      :approved,
      :geocoded,
      account: FactoryBot.create(:account, email: "engineering+factorycha@technovation.org", last_name: "a")
    )
    chapter_ambassador.background_check.destroy

    sign_in(chapter_ambassador)

    click_link "Background Check"
    click_link "Submit Background Check"

    expect(page).to have_link("Request background check invitation")
    click_link "Request background check invitation"

    expect(page).to have_text("Checkr requires last name to contain at least 2 alpha characters. Please edit your last name.")
  end
end
