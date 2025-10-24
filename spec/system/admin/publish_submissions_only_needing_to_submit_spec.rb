require "rails_helper"

RSpec.describe "Publishing submissions that only need to submit", :js do
  before do
    allow(SeasonToggles).to receive(:team_submissions_editable?).and_return(team_submissions_editable)
    allow(SeasonToggles).to receive(:judging_enabled?).and_return(judging_enabled)
  end

  let(:team_submissions_editable) { false }
  let(:judging_enabled) { false }

  context "as a super admin" do
    before do
      sign_in(:super_admin)
    end

    it "displays the 'Publish Submissions' menu item" do
      expect(page).to have_link("Publish Submissions")
    end

    context "when editing submissions and juding is turned off" do
      let(:team_submissions_editable) { false }
      let(:judging_enabled) { false }

      it "displays a section to publish submissions that only need to submit" do
        click_link "Publish Submissions"

        expect(page).to have_text("Publish Submissions Only Needing to Submit")
      end

      context "when there is a submission that only needs submitting" do
        let!(:submission) { FactoryBot.create(:submission, :only_needs_to_submit) }

        it "displays a Publish button" do
          click_link "Publish Submissions"

          expect(page).to have_current_path("/admin/team_submissions/bulk_publish")
          expect(page).to have_link("Publish")
        end

        it "displays the submission's name" do
          click_link "Publish Submissions"

          expect(page).to have_current_path("/admin/team_submissions/bulk_publish")
          expect(page).to have_link(submission.app_name)
        end

        it "publishes the submission" do
          click_link "Publish Submissions"
          click_link "Publish"
          click_button "Yes, do it"

          expect(page).to have_current_path("/admin/team_submissions/bulk_publish")
          expect(page).to have_text("There aren't any submissions needing to be published at this time.")
          expect(submission.reload).to be_published
        end
      end

      context "when there aren't any submissions to publish" do
        let!(:submission) { FactoryBot.create(:submission, :incomplete) }

        it "displays a message indicating there aren't any submissions to publish" do
          click_link "Publish Submissions"

          expect(page).to have_current_path("/admin/team_submissions/bulk_publish")
          expect(page).to have_text("There aren't any submissions needing to be published at this time.")
        end
      end
    end

    context "when editing submissions is turned on" do
      let(:team_submissions_editable) { true }

      it "displays a message indicating when submissions can be published" do
        click_link "Publish Submissions"

        expect(page).to have_current_path("/admin/team_submissions/bulk_publish")
        expect(page).to have_text("Submissions can only be published when editing submissions is turned off.")
      end
    end

    context "when juding is turned on" do
      let(:judging_enabled) { true }

      it "displays a message indicating when submissions can be published" do
        click_link "Publish Submissions"

        expect(page).to have_current_path("/admin/team_submissions/bulk_publish")
        expect(page).to have_text("Submissions can't be published when judging is turned on.")
      end
    end
  end

  context "as an admin" do
    before do
      sign_in(:admin)
    end

    it "does not display the 'Publish Submissions' menu item" do
      expect(page).not_to have_link("Publish Submissions")
    end
  end
end
