require "rails_helper"

RSpec.xfeature "Mentor receives welcome email", js: true do
  let(:mentor) { FactoryBot.create(:mentor) }

  background(:each) do
    clear_emails
    open_email(mentor.email)
  end

  context "already logged in" do
    before do
      sign_in mentor
    end

    scenario "successfully signing the consent waiver" do
      current_email.click_link 'Sign the consent waiver'
      expect(page).to have_content("Technovation Volunteer Agreement")

      fill_in "Type your name", with: "me"
      click_button "I agree"

      expect(page).to have_content("Thank you for signing the consent waiver")
    end
  end

  context "logged out" do
    scenario "the consent waiver link logs you in" do
      current_email.click_link 'Sign the consent waiver'
      expect(page).to have_content("Technovation Volunteer Agreement")
      expect(page).to have_content("LOGOUT")
    end
  end
end
