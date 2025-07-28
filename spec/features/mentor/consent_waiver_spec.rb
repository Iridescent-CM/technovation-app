require "rails_helper"

RSpec.feature "Consent waivers", js: true do
  let(:mentor) do
    mentor = FactoryBot.create(:mentor)
    mentor.consent_waiver.destroy
    mentor
  end

  before { sign_in mentor }

  scenario "invalid token" do
    [{}, {token: "bad"}].each do |bad_token_params|
      visit new_mentor_consent_waiver_path(bad_token_params)
      expect(current_path).to eq(mentor_dashboard_path)
      expect(page).to have_content("Sorry, that consent token was invalid.")
    end
  end

  scenario "valid token, valid code of conduct, invalid signature form" do
    visit mentor_dashboard_path

    click_link "Consent Waiver"
    click_link "Sign Consent Waiver"

    check "read_and_understands_code_of_conduct"
    check "acknowledges_consequences_of_code_of_conduct"
    click_button "I agree"

    expect(current_path).to eq(mentor_consent_waivers_path)
    expect(page).to have_css(
      ".consent_waiver_electronic_signature .error",
      text: "can't be blank"
    )
  end

  scenario "valid token, invalid code of conduct, valid signature form" do
    visit mentor_dashboard_path

    click_link "Consent Waiver"
    click_link "Sign Consent Waiver"

    fill_in "Type your name as a form of electronic signature",
      with: "Menty Meadows"

    expect(page).to have_selector("#submit[disabled]")
  end

  scenario "valid token, valid code of conduct, valid signature" do
    visit mentor_dashboard_path

    click_link "Consent Waiver"
    click_link "Sign Consent Waiver"

    check "read_and_understands_code_of_conduct"
    check "acknowledges_consequences_of_code_of_conduct"

    fill_in "Type your name as a form of electronic signature",
      with: "Mentor McGee"
    click_button "I agree"

    expect(current_path).to eq(mentor_dashboard_path)
    expect(page).to have_content("Thank you for signing the consent waiver!")
  end

  scenario "shows signed message if already signed" do
    FactoryBot.create(:consent_waiver, account: mentor.account)

    visit mentor_consent_waiver_path

    expect(page).to have_content("You already signed a consent waiver for this season. Thank you!")
    expect(page).not_to have_link("Sign Consent Waiver")
  end

  scenario "shows sign button if not yet signed" do
    visit mentor_consent_waiver_path

    expect(page).to have_content("Please sign the consent waiver in order to participate in Technovation.")
    expect(page).to have_link("Sign Consent Waiver")
  end
end
