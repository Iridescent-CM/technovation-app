require "rails_helper"

RSpec.describe "Publishing a submission from the dashboard" do
  before { SeasonToggles.team_submissions_editable! }

  context "as a student" do
    it "displays a button on the dashboard as their final step" do
      student = FactoryBot.create(:student, :onboarded, :on_team)
      submission = FactoryBot.create(:submission, :complete, team: student.team)
      submission.update(published_at: nil)

      sign_in(student)

      expect(page).to have_link(
        "Review and submit now!",
        href: student_published_team_submission_path(submission)
      )
    end

    context "who is reviewing the submission" do
      it "displays a thunkable URL for the source code" do
        student = FactoryBot.create(:student, :onboarded, :on_team)
        submission = FactoryBot.create(:submission, :complete, :thunkable, team: student.team)
        submission.update(published_at: nil)

        sign_in(student)

        click_link "Review and submit now!"

        within(".source-code") do
          expect(page).to have_link(
            "Open this project in Thunkable",
            href: submission.thunkable_project_url
          )
        end
      end
    end
  end

  context "as a mentor" do
    it "displays a button on the dashboard as their final step" do
      student = FactoryBot.create(:student, :onboarded, :on_team)
      mentor = FactoryBot.create(:mentor, :onboarded)

      TeamRosterManaging.add(student.team, mentor)
      submission = FactoryBot.create(:submission, :complete, team: student.team)
      submission.update(published_at: nil)

      sign_in(mentor)

      within("#find-team") do
        expect(page).to have_link(
          "Review and submit now!",
          href: mentor_published_team_submission_path(submission)
        )
      end
    end

    context "who is reviewing the submission" do
      it "displays a thunkable URL for the source code" do
        student = FactoryBot.create(:student, :onboarded, :on_team)
        mentor = FactoryBot.create(:mentor, :onboarded)

        TeamRosterManaging.add(student.team, mentor)
        submission = FactoryBot.create(:submission, :complete, :thunkable, team: student.team)
        submission.update(published_at: nil)

        sign_in(mentor)

        within("#find-team") do
          click_link "Review and submit now!"
        end

        within(".source-code") do
          expect(page).to have_link(
            "Open this project in Thunkable",
            href: submission.thunkable_project_url
          )
        end
      end
    end
  end
end