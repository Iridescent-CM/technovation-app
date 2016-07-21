require "rails_helper"

RSpec.feature "Parental consent" do
  scenario "invalid token" do
    [{ }, { token: "bad" }].each do |bad_token_params|
      visit new_parental_consent_path(bad_token_params)
      expect(current_path).to eq(application_dashboard_path)
      expect(page).to have_content("Sorry, that consent token was invalid.")
    end
  end

  scenario "valid token, invalid signature form" do
    student = FactoryGirl.create(:student)
    visit new_parental_consent_path(token: student.consent_token)
    click_button "I agree"
    expect(current_path).to eq(parental_consents_path)
    expect(page).to have_css('.parental_consent_consent_confirmation .error', text: 'must be confirmed')
    expect(page).to have_css('.parental_consent_electronic_signature .error', text: "can't be blank")
  end

  scenario "valid token, valid form" do
    student = FactoryGirl.create(:student)
    visit new_parental_consent_path(token: student.consent_token)

    check "Check this box to confirm your consent"
    fill_in "Electronic signature", with: "Parent M. McGee"
    click_button "I agree"

    expect(current_path).to eq(parental_consent_path(ParentalConsent.last))
    expect(page).to have_content("#{student.full_name} has been consented by #{student.parental_consent_electronic_signature} on #{student.parental_consent_signed_at.strftime("%-d %B, %Y")}")
  end
end
