require "rails_helper"

RSpec.describe "Register as a mentor", :js do
  before do
    allow(SubscribeEmailListJob).to receive(:perform_later)

    set_signup_token("mentor@mentor.com")

    visit mentor_signup_path

    fill_in "First name", with: "Mentor"
    fill_in "Last name", with: "McGee"

    select_chosen_date Date.today - 31.years, from: "Date of birth"

    select_gender(:random)

    fill_in_vue_select "School or company name", with: "John Hughes High."
    fill_in "Job title", with: "Janitor / Man of the Year"

    MentorProfile.mentor_types.keys.shuffle.each do |mentor_type|
      select mentor_type, from: "I am a..."
    end

    click_button "Create Your Account"
  end

  it "redirects to the mentor dashboard" do
    expect(current_path).to eq(mentor_dashboard_path)
  end

  it "saves the mentor type" do
    expect(MentorProfile.last.mentor_type).not_to be_nil
  end

  it "attaches the signup attempt" do
    attempt = SignupAttempt.find_by(
      account_id: MentorProfile.last.account_id
    )
    expect(attempt).to be_present
  end

  it "Email list subscribed" do
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
