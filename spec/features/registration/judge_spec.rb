require "rails_helper"

RSpec.feature "Judges registering", :js do
  before do
    SeasonToggles.registration_open!

    visit "/signup"
  end

  scenario "Judge registration steps and fields" do
    choose "I am over 18 years old and will judge submissions"
    click_button "Next"

    expect(page).to have_content("Judge Information")

    fill_in "First Name", with: "Funshine"
    fill_in "Last Name", with: "Bear"
    select "Prefer not to say", from: "Gender Identity"
    fill_in "Birthday", with: 41.years.ago
    fill_in "Company Name", with: "Care-a-Lot"
    fill_in "Job Title", with: "Class clown"
    click_button "Next"

    expect(page).to have_content("Data Use Terms")

    check "I AGREE TO THESE DATA USE TERMS"
    click_button "Next"

    expect(page).to have_content("Set your email and password")

    fill_in "Email Address", with: "funshine@test.com"
    fill_in "Password", with: "secret12345"
    click_button "Submit this form"
  end
end
