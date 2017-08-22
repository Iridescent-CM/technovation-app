require "rails_helper"

RSpec.feature "Mentors find a team" do
  let!(:find_mentor) {
    FactoryGirl.create(:mentor, :geocoded, first_name: "Findme")
  } # City is Chicago

  before do
    mentor = FactoryGirl.create(:mentor, :geocoded) # City is Chicago
    sign_in(mentor)
  end

  scenario "browse nearby mentors" do
    FactoryGirl.create(
      :mentor,
      :geocoded,
      first_name: "Faraway",
      city: "Los Angeles",
      state_province: "CA"
    )

    click_link "Connect with mentors"

    within(".search-result-head") do
      expect(page).to have_content("Findme")
      expect(page).not_to have_content("Faraway")
    end
  end

  scenario "visit the mentor page" do
    click_link "Connect with mentors"
    click_link "Ask"

    expect(page).to have_css(
      "a[href=\"mailto:#{find_mentor.email}\"]",
      text: find_mentor.email
    )
  end
end
