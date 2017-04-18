require "rails_helper"

RSpec.feature "Mentors find a team" do
  let!(:find_mentor) { FactoryGirl.create(:mentor, first_name: "Findme") } # City is Chicago

  before do
    mentor = FactoryGirl.create(:mentor) # City is Chicago
    sign_in(mentor)
  end

  scenario "browse nearby mentors" do
    FactoryGirl.create(:mentor, first_name: "Faraway",
                                city: "Los Angeles",
                                state_province: "CA")

    click_link "Connect with mentors"

    expect(page).to have_css(".mentor__name", text: "Findme")
    expect(page).not_to have_css(".mentor__name", text: "Faraway")
  end

  scenario "visit the mentor page" do
    click_link "Connect with mentors"
    click_link "View Full Profile"

    expect(page).to have_css("a[href=\"mailto:#{find_mentor.email}\"]", text: find_mentor.email)
  end
end
