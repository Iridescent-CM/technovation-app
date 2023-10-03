require "rails_helper"

RSpec.feature "Students registering", :js do
  before do
    SeasonToggles.registration_open!

    visit "/signup"
  end

  scenario "Student registration steps and fields" do
    choose "I am registering myself and am 13-18 years old"
    click_button "Next"

    expect(page).to have_content("Student Information")

    fill_in "First Name", with: "Harmony"
    fill_in "Last Name", with: "Bear"
    fill_in "Birthday", with: 17.years.ago
    fill_in "School Name", with: "Care-a-Lot High School"
    within "#parent-information" do
      fill_in "Name", with: "Brave Heart Lion"
    end
    click_button "Next"

    expect(page).to have_content("Data Use Terms")

    check "I AGREE TO THESE DATA USE TERMS"
    click_button "Next"

    expect(page).to have_content("Set your email and password")

    fill_in "Email Address", with: "harmony@test.com"
    fill_in "Password", with: "secret12345"
    click_button "Submit this form"
  end
end
