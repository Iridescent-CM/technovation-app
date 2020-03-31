require "rails_helper"

RSpec.feature "RAs switch to mentor mode", :js do

  scenario "an RA switches to mentor mode with a mentor profile" do
    ra = FactoryBot.create(:regional_ambassador, :approved)
    CreateMentorProfile.(ra)

    sign_in(ra)
    click_link "Mentor Mode"
    expect(page).to have_link("Switch to RA mode")

    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "an RA switches to mentor mode without a mentor profile" do
    ra = FactoryBot.create(:regional_ambassador, :approved)

    sign_in(ra)
    click_link "Mentor Mode"
    expect(page).to have_link("Switch to RA mode")

    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "an RA switches back to RA mode from mentor mode" do
    ra = FactoryBot.create(:regional_ambassador, :approved)

    sign_in(ra)
    click_link "Mentor Mode"
    click_link "RA mode"

    expect(current_path).to eq(regional_ambassador_dashboard_path)
  end

  scenario "a mentor without an RA profile cannot switch to RA mode" do
    mentor = FactoryBot.create(:mentor, :onboarded)
    sign_in(mentor)
    expect(page).not_to have_link("RA mode")

    visit regional_ambassador_dashboard_path
    expect(current_path).to eq(mentor_dashboard_path)
  end
end
