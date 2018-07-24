require "rails_helper"

RSpec.describe "Mentors register with their location", :js do
  before do
    SeasonToggles.enable_signups!

    set_signup_token("mentor@mentor.com")

    visit mentor_signup_path

    fill_in "First name", with: "Mentor"
    fill_in "Last name", with: "McGee"

    select_chosen_date Date.today - 31.years, from: "Date of birth"

    fill_in_vue_select "School or company name", with: "John Hughes High"
    fill_in "Job title", with: "Janitor / Man of the Year"

    MentorProfile.mentor_types.keys.shuffle.each do |mentor_type|
      select mentor_type, from: "I am a..."
    end

    click_button "Create Your Account"
  end

  it "saves location details" do
    click_link "Update your location"

    fill_in "City", with: "Chicago"
    fill_in "State / Province", with: "IL"
    fill_in "Country / Territory", with: "United States"
    click_button "Next"

    visit mentor_profile_path(anchor: '!location')
    expect(page).to have_content("Chicago, IL, United States")
  end
end