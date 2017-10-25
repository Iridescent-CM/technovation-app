require "rails_helper"

RSpec.feature "Consent waivers" do
  scenario "invalid token" do
    [{ }, { token: "bad" }].each do |bad_token_params|
      visit new_consent_waiver_path(bad_token_params)
      expect(current_path).to eq(application_dashboard_path)
      expect(page).to have_content("Sorry, that consent token was invalid.")
    end
  end

  scenario "valid token, invalid signature form" do
    mentor = FactoryGirl.create(:mentor)
    mentor.consent_waiver.destroy

    sign_in(mentor)
    visit mentor_dashboard_path

    click_link "Sign Consent Waiver"
    click_button "I agree"

    expect(current_path).to eq(consent_waivers_path)
    expect(page).to have_css(
      '.consent_waiver_electronic_signature .error',
      text: "can't be blank"
    )
  end

  scenario "valid token, valid form" do
    mentor = FactoryGirl.create(:mentor)
    mentor.consent_waiver.destroy

    sign_in(mentor)

    visit mentor_dashboard_path
    click_link "Sign Consent Waiver"

    fill_in "Electronic signature", with: "Mentor McGee"
    click_button "I agree"

    expect(current_path).to eq(mentor_dashboard_path)
    expect(page).to have_content("Thank you for signing the consent waiver!")
  end
end
