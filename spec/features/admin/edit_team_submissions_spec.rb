require "rails_helper"

RSpec.feature "Toggling editable team submissions" do
  context "as a mentor" do
    scenario "editing on" do
      SeasonToggles.team_submissions_editable = true

      mentor = FactoryGirl.create(:mentor)
      team = FactoryGirl.create(:team)

      TeamRosterManaging.add(team, mentor)
      sign_in(mentor)

      within("#team-submission-team-list-team-#{team.id}") do
        click_link "Start the submission for this team"
      end

      check "team_submission[integrity_affirmed]"
      click_button "Get Started"

      expect(page).to have_css('.appy-button', text: "Edit")

      visit mentor_dashboard_path

      within("#team-submission-team-list-team-#{team.id}") do
        expect(page).not_to have_content("The submission deadline has passed.")
        expect(page).to have_link(
          "Edit this team's submission",
          href: mentor_team_submission_path(team.submission, team_id: team.id)
        )
      end
    end

    scenario "editing off" do
      SeasonToggles.team_submissions_editable = false

      mentor = FactoryGirl.create(:mentor)
      team = FactoryGirl.create(:team)
      FactoryGirl.create(:submission, team: team)

      TeamRosterManaging.add(team, mentor)
      sign_in(mentor)

      within("#team-submission-team-list-team-#{team.id}") do
        expect(page).to have_content("The submission deadline has passed.")
        expect(page).not_to have_link("Edit this team's submission")
      end

      visit mentor_team_submission_path(team.submission, team_id: team.id)
      expect(page).not_to have_css(".appy-button", text: "Edit")
    end
  end

  context "as a student" do
    scenario "editing on" do
      SeasonToggles.team_submissions_editable = true

      student = FactoryGirl.create(:student)
      team = FactoryGirl.create(:team)

      TeamRosterManaging.add(team, student)
      sign_in(student)

      within("#your-submission") { click_link "Begin your submission" }
      check "team_submission[integrity_affirmed]"
      click_button "Get Started"

      expect(page).to have_css('.appy-button', text: "Edit")

      visit student_dashboard_path
      within("#your-submission") do
        expect(page).not_to have_content("The submission deadline has passed.")
        expect(page).to have_link(
          "Edit your submission",
          href: student_team_submission_path(team.submission)
        )
      end
    end

    scenario "editing off, submission exists" do
      SeasonToggles.team_submissions_editable = false

      student = FactoryGirl.create(:student)
      team = FactoryGirl.create(:team)
      FactoryGirl.create(:submission, team: team)

      TeamRosterManaging.add(team, student)
      sign_in(student)

      expect(page).to have_content("The submission deadline has passed.")
      expect(page).not_to have_link("Edit your submission")

      visit student_team_submission_path(team.submission)
      expect(page).not_to have_css(".appy-button", text: "Edit")
    end

    scenario "editing off, no submission exists" do
      SeasonToggles.team_submissions_editable = false

      student = FactoryGirl.create(:student)
      team = FactoryGirl.create(:team)

      TeamRosterManaging.add(team, student)
      sign_in(student)

      expect(page).to have_content("The submission deadline has passed.")
      expect(page).not_to have_link("Begin your submission")
    end
  end
end
