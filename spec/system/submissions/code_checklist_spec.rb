require "rails_helper"

RSpec.describe "Using the code checklist UI", :js do
  before { SeasonToggles.team_submissions_editable! }

  context "as a student" do
    context "when I select the maximum options" do
      it "lets me change my options" do
        student = FactoryBot.create(:student, :on_team, :submitted)

        sign_in(student)
        click_link "Code checklist"

        check "Local Database"
        uncheck "Local Database"

        check "External Database or API"
        expect(
          page.find(:css, "#technical_checklist_used_external_db_explanation")
        ).to be_visible
      end
    end
  end

  context "as a mentor" do
    context "when I select the maximum options" do
      it "lets me change my options" do
        mentor = FactoryBot.create(:mentor, :on_team, :submitted)

        sign_in(mentor)

        click_link "Edit this team's submission"
        click_link "Code checklist"

        check "Local Database"
        uncheck "Local Database"

        check "External Database or API"
        expect(
          page.find(:css, "#technical_checklist_used_external_db_explanation")
        ).to be_visible
      end
    end
  end
end