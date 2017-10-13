require "rails_helper"

RSpec.feature "RAs switch to mentor mode" do
  scenario "an RA switches to mentor mode with a mentor profile" do
    skip "Not there yet"
    ra = FactoryGirl.create(:regional_ambassador, :approved)
    CreateMentorProfile.(ra)

    sign_in(ra)
    click_link "Mentor mode"

    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "an RA switches to mentor mode without a mentor profile" do
    skip "Not there yet"
    ra = FactoryGirl.create(:regional_ambassador, :approved)

    sign_in(ra)
    click_link "Mentor mode"

    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "an RA switches back to RA mode from mentor mode" do
    skip "Not there yet"
    ra = FactoryGirl.create(:regional_ambassador, :approved)

    sign_in(ra)
    click_link "Mentor mode"
    click_link "RA mode"

    expect(current_path).to eq(regional_ambassador_participants_path)
  end

  scenario "a mentor without an RA profile cannot switch to RA mode" do
    skip "Not there yet"
    mentor = FactoryGirl.create(:mentor)
    sign_in(mentor)
    expect(page).not_to have_link("RA mode")

    visit regional_ambassador_dashboard_path
    expect(current_path).to eq(mentor_dashboard_path)
  end
end
