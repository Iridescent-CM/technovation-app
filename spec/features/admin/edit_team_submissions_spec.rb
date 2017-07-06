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
        expect(page).to have_link(
          'Start the submission for this team',
          href: new_mentor_team_submission_path(team_id: team.id)
        )
      end
    end

    scenario "editing off" do
      SeasonToggles.team_submissions_editable = false

      mentor = FactoryGirl.create(:mentor)
      team = FactoryGirl.create(:team)

      TeamRosterManaging.add(team, mentor)
      sign_in(mentor)

      within("#team-submission-team-list-team-#{team.id}") do
        expect(page).to have_content("The submission deadline has passed.")
      end
    end
  end

  context "as a student" do
    scenario "editing on" do
      SeasonToggles.team_submissions_editable = true

      student = FactoryGirl.create(:student)
      team = FactoryGirl.create(:team)

      TeamRosterManaging.add(team, student)
      sign_in(student)

      within("#your-submission") do
        expect(page).to have_link(
          'Begin your submission',
          href: new_student_team_submission_path
        )
      end
    end

    scenario "editing off" do
      SeasonToggles.team_submissions_editable = false

      student = FactoryGirl.create(:student)
      team = FactoryGirl.create(:team)

      TeamRosterManaging.add(team, student)
      sign_in(student)

      within("#your-submission") do
        expect(page).to have_content("The submission deadline has passed.")
      end
    end
  end
end
