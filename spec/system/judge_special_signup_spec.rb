require "rails_helper"

RSpec.describe "Judges sign up at special link", :js do
  it "visit the normal url" do
    visit judge_signup_path
    expect(current_path).to eq(root_path)
  end

  it "visit with the special token" do
    invitation = GlobalInvitation.create!

    visit judge_signup_path(invitation: invitation.token)

    expect(current_path).to eq(judge_signup_path)

    expect(page).to have_css("#new_judge_profile input[type=email]")
    expect(page).to have_css("#new_judge_profile input[type=password]")
  end

  it "sign up" do
    invitation = GlobalInvitation.create!

    visit judge_signup_path(invitation: invitation.token)

    fill_in "Email", with: "my@email.com"
    fill_in "First name", with: "Judgey"
    fill_in "Last name", with: "McJudgeface"
    select_chosen_date 20.years.ago, from: "Date of birth"
    select_gender(:random)
    fill_in "School or company name", with: "testing"
    fill_in "Job title", with: "test"
    fill_in "Create a password", with: "secret1234"

    click_button "Create Your Account"

    expect(page).to have_current_path(
      edit_terms_agreement_path, ignore_query: true
    )

    expect(page).to have_selector('#terms_agreement_checkbox', visible: true)

    check "terms_agreement_checkbox"

    click_button "Submit"

    expect(page).to have_current_path(
      judge_location_details_path, ignore_query: true
    )

    expect(page).to have_selector('#location_city', visible: true)
    expect(page).to have_selector('#location_state', visible: true)
    expect(page).to have_selector('#location_country', visible: true)

    fill_in "State / Province", with: "California"
    fill_in "City", with: "Los Angeles"
    fill_in "Country", with: "United States"

    click_button "Next"
    click_button "Confirm"

    expect(page).to have_current_path(judge_dashboard_path, ignore_query: true)
  end

  it "encounter validation errors with the special token" do
    invitation = GlobalInvitation.create!

    visit judge_signup_path(invitation: invitation.token)

    expect(current_path).to eq(judge_signup_path)

    click_button "Create Your Account"

    expect(page).to have_css(
      "#new_judge_profile .field_with_errors input[type=email]"
    )

    expect(page).to have_css(
      "#new_judge_profile .field_with_errors input[type=password]"
    )
  end
end
