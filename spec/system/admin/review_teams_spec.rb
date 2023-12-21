require "rails_helper"

RSpec.describe "Admins reviewing teams" do
  describe "individual team view" do
    it "links to students who are currently pending and not fully onboarded" do
      onboarding_student = FactoryBot.create(:student, :onboarding)

      team = FactoryBot.create(:team)

      TeamRosterManaging.add(team, onboarding_student)

      sign_in(:admin)

      click_link "Teams"
      click_link "view"

      expect(current_path).to eq(admin_team_path(team))

      within(".onboarding_students") do
        expect(page).to have_content(onboarding_student.full_name)
        click_link onboarding_student.full_name
        expect(current_path).to eq(admin_participant_path(onboarding_student.account_id))
      end
    end
  end
end
