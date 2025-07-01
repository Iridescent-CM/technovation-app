require "rails_helper"

RSpec.feature "chapter ambassadors switch to mentor mode", :js do
  scenario "a chapter ambassador switches to mentor mode with a mentor profile" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)
    CreateMentorProfile.call(chapter_ambassador)

    sign_in(chapter_ambassador)
    click_link "Mentor Mode"

    expect(page).to have_selector("a", text: "Switch to Chapter Ambassador Mode", visible: false)

    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "a chapter ambassador switches to mentor mode without a mentor profile" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)

    sign_in(chapter_ambassador)
    click_link "Mentor Mode"
    expect(page).to have_selector("a", text: "Switch to Chapter Ambassador Mode", visible: false)

    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "a chapter ambassador switches back to chapter ambassador mode from mentor mode" do
    chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)

    sign_in(chapter_ambassador)
    click_link "Mentor Mode"

    visit chapter_ambassador_dashboard_path
    expect(current_path).to eq(chapter_ambassador_dashboard_path)
  end

  scenario "a mentor without a chapter ambassador profile cannot switch to chapter ambassador mode" do
    mentor = FactoryBot.create(:mentor, :onboarded)
    sign_in(mentor)
    expect(page).not_to have_link("Chapter Ambassador mode")

    visit chapter_ambassador_dashboard_path
    expect(current_path).to eq(mentor_dashboard_path)
  end
end
