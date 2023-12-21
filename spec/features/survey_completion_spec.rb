require "rails_helper"

RSpec.feature "Survey completion" do
  %i[student mentor].each do |scope|
    scenario "redirection for #{scope} after logging in still works" do
      user = FactoryBot.create(scope)

      visit survey_completion_path

      # redirect to sign in
      fill_in "Email", with: user.account.email
      fill_in "Password", with: "secret1234"
      click_button "Sign in"

      expect(current_path).to eq(send("#{scope}_dashboard_path"))
      expect(user.account.reload).to be_took_program_survey
    end
  end
end
