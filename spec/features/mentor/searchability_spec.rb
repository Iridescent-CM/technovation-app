require "rails_helper"

RSpec.feature "Searchability" do
  scenario "non-US mentor signs consent" do
    mentor = FactoryBot.create(
      :mentor,
      city: "Salvador",
      state_province: "Bahia",
      country: "BR",
      not_onboarded: true
    )

    expect(mentor).not_to be_searchable

    sign_in(mentor)
    visit mentor_dashboard_path
    visit mentor_training_completion_path
    click_link "Sign Consent Waiver"

    fill_in "Type your name as a form of electronic signature",
      with: "Mentor McGee"
    click_button "I agree"

    expect(mentor.reload).to be_searchable
  end

  scenario "US mentor signs consent, passes bg check", :vcr do
    mentor = FactoryBot.create(
      :mentor,
      country: "US",
      not_onboarded: true
    )

    expect(mentor).not_to be_searchable

    sign_in(mentor)
    visit mentor_dashboard_path
    visit mentor_training_completion_path
    click_link "Sign Consent Waiver"

    fill_in "Type your name as a form of electronic signature",
      with: "Mentor McGee"
    click_button "I agree"

    expect(mentor.reload).not_to be_searchable

    click_link "Submit Background Check"
    fill_in "Zipcode", with: 60622
    fill_in "Ssn", with: "111-11-2001"
    fill_in "Driver license state", with: "CA"
    click_button "Submit"

    click_link "Check Submission Status"
    expect(page).to have_content("status is: pending")
    expect(mentor.reload).not_to be_searchable
  end

  scenario "US mentor passes bg check, signs consent", :vcr do
    mentor = FactoryBot.create(:mentor, country: "US", not_onboarded: true)
    expect(mentor).not_to be_searchable

    sign_in(mentor)
    visit mentor_dashboard_path
    visit mentor_training_completion_path
    click_link "Submit Background Check"

    fill_in "Zipcode", with: 60622
    fill_in "Ssn", with: "111-11-2001"
    fill_in "Driver license state", with: "CA"
    click_button "Submit"

    click_link "Check Submission Status"
    expect(page).to have_content("status is: pending")
    expect(mentor.reload).not_to be_searchable

    visit mentor_dashboard_path
    click_link "Sign Consent Waiver"

    fill_in "Type your name as a form of electronic signature",
      with: "Mentor McGee"
    click_button "I agree"

    expect(mentor.reload).not_to be_searchable
  end
end
