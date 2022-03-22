require "rails_helper"

RSpec.feature "Judge onboarding" do
  let(:judge) { FactoryBot.create(:judge) }

  scenario "signing the consent form" do
    sign_in judge
    click_link "Consent Waiver"

    fill_in "Type your name", with: "me"
    click_button "I agree"

    expect(page).to have_content("Thank you for signing the consent waiver")
  end
end