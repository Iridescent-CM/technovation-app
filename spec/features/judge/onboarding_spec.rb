require "rails_helper"

RSpec.feature "Judge onboarding", js: true do
  let(:judge) { FactoryBot.create(:judge) }

  scenario "signing the consent form" do
    sign_in judge
    click_link "Consent Waiver"

    check "read_and_understands_code_of_conduct"
    check "acknowledges_consequences_of_code_of_conduct"
    fill_in "Type your name", with: "me"
    click_button "I agree"

    expect(page).to have_content("Thank you for signing the consent waiver")
  end
end
