require "rails_helper"

RSpec.feature "Register as a mentor" do
  before do
    allow(SubscribeEmailListJob).to receive(:perform_later)

    set_signup_token("mentor@mentor.com")

    visit mentor_signup_path

    fill_in "First name", with: "Mentor"
    fill_in "Last name", with: "McGee"

    select_date Date.today - 31.years, from: "Date of birth"

    fill_in "School or company name", with: "John Hughes High."
    fill_in "Job title", with: "Janitor / Man of the Year"

    MentorProfile.mentor_types.keys.shuffle.each do |mentor_type|
      select mentor_type, from: "I am a..."
    end

    click_button "Create Your Account"
  end

  scenario "Redirected to mentor dashboard" do
    expect(current_path).to eq(mentor_dashboard_path)
  end

  scenario "saves the mentor type" do
    expect(MentorProfile.last.mentor_type).not_to be_nil
  end

  scenario "saves location details" do
    allow(UpdateProfileOnEmailListJob).to receive(:perform_later)

    click_link "Update your location"

    fill_in "City", with: "Chicago"
    fill_in "State / Province", with: "IL"
    select "United States", from: "Region"
    click_button "Save"

    expect(MentorProfile.last.address_details).to eq(
      "Chicago, IL, United States"
    )
    expect(UpdateProfileOnEmailListJob).to have_received(:perform_later)
      .with(
        MentorProfile.last.account_id,
        "mentor@mentor.com",
        "MENTOR_LIST_ID",
    )
  end

  scenario "signup attempt attached" do
    attempt = SignupAttempt.find_by(
      account_id: MentorProfile.last.account_id
    )
    expect(attempt).to be_present
  end

  scenario "Email list subscribed" do
    expect(SubscribeEmailListJob).to have_received(:perform_later)
      .with(
        "mentor@mentor.com",
        "Mentor McGee",
        "MENTOR_LIST_ID",
        [
          { Key: 'City', Value: nil },
          { Key: 'State/Province', Value: nil },
          { Key: 'Country', Value: "" },
        ]
      )
  end
end
