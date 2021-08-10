require "rails_helper"

RSpec.describe "Mentors register with their location", :js do
  before do
    SeasonToggles.enable_signups!

    set_signup_token("mentor@mentor.com")

    visit mentor_signup_path

    fill_in "First name", with: "Mentor"
    fill_in "Last name", with: "McGee"

    select_chosen_date Date.today - 31.years, from: "Date of birth"

    select_gender(:random)

    fill_in "School or company name", with: "John Hughes High"
    fill_in "Job title", with: "Janitor / Man of the Year"

    MentorProfile.mentor_types.keys.shuffle.each do |mentor_type|
      select mentor_type, from: "I am a..."
    end

    click_button "Create Your Account"

    expect(page).to have_current_path(
      edit_terms_agreement_path, ignore_query: true
    )

    expect(page).to have_selector('#terms_agreement_checkbox', visible: true)

    check "terms_agreement_checkbox"

    click_button "Submit"

    expect(page).to have_current_path(
      mentor_location_details_path, ignore_query: true
    )

    expect(page).to have_selector('#location_city', visible: true)
    expect(page).to have_selector('#location_state', visible: true)
    expect(page).to have_selector('#location_country', visible: true)

    fill_in "State / Province", with: "California"
    fill_in "City", with: "Los Angeles"
    fill_in "Country", with: "United States"

    click_button "Next"
    click_button "Confirm"
  end

  it "saves location details" do
    click_button "Profile"
    click_button "Region"

    fill_in "Country / Territory", with: ""
    fill_in "State / Province", with: ""
    fill_in "City", with: ""

    fill_in "Country / Territory", with: "United States"
    fill_in "State / Province", with: "IL"
    fill_in "City", with: "Chicago"

    click_button "Next"
    expect(page).to have_content("Confirm")
    click_button "Confirm"

    visit mentor_profile_path(anchor: '!location')
    expect(page).to have_content("Chicago, Illinois, United States")
  end
end
