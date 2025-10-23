require "rails_helper"

RSpec.describe "Publishing a submission", :js do
  context "when a submission only needs to be published" do
    let!(:submission) { FactoryBot.create(:submission, :only_needs_to_submit) }

    context "as a super admin" do
      before do
        sign_in(:super_admin)
      end

      it "displays a link to publish the submission" do
        click_link "Submissions"
        click_link submission.app_name

        within(".edit-team-submission-buttons") do
          expect(page).to have_link("Publish")
        end
      end

      it "successfully publishes a submission" do
        click_link "Submissions"
        click_link submission.app_name

        within(".edit-team-submission-buttons") do
          click_link "Publish"
        end

        click_button "Yes, do it"

        expect(page).to have_link("Unpublish")
        expect(submission.reload).to be_published
      end
    end

    context "as an admin" do
      before do
        sign_in(:admin)
      end

      it "does not display a link to publish the submission" do
        click_link "Submissions"
        click_link submission.app_name

        within(".edit-team-submission-buttons") do
          expect(page).not_to have_link("Publish")
        end
      end
    end
  end

  context "when a submission is incomplete (it needs more than just publishing)" do
    let!(:incomplete_submission) { FactoryBot.create(:submission, :incomplete) }

    context "as a super admin" do
      before do
        sign_in(:super_admin)
      end

      it "does not display a link to publish the submission" do
        click_link "Submissions"
        click_link incomplete_submission.app_name

        within(".edit-team-submission-buttons") do
          expect(page).not_to have_link("Publish")
        end
      end
    end

    context "as an admin" do
      before do
        sign_in(:admin)
      end

      it "does not display a link to publish the submission" do
        click_link "Submissions"
        click_link incomplete_submission.app_name

        within(".edit-team-submission-buttons") do
          expect(page).not_to have_link("Publish")
        end
      end
    end
  end
end
