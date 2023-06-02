require "rails_helper"

RSpec.describe "Unpublishing a submission", :js do
  context "when a submisison is complete" do
    let!(:submission) { FactoryBot.create(:submission, :complete) }

    context "as a super admin" do
      before do
        sign_in(:super_admin)
      end

      it "displays a link to unpublish the submission" do
        click_link "Submissions"
        click_link submission.app_name

        expect(page).to have_link("Unpublish")
      end

      it "successfully unpublishes a submission" do
        click_link "Submissions"
        click_link submission.app_name
        click_link "Unpublish"
        click_button "Yes, do it"

        expect(submission.reload).not_to be_published
      end
    end

    context "as an admin" do
      before do
        sign_in(:admin)
      end

      it "does not display a link to unpublish the submission" do
        click_link "Submissions"
        click_link submission.app_name

        expect(page).not_to have_link("Unpublish")
      end
    end
  end

  context "when a submisison is incomplete" do
    let!(:incomplete_submission) { FactoryBot.create(:submission, :incomplete) }

    context "as a super admin" do
      before do
        sign_in(:super_admin)
      end

      it "does not display a link to unpublish the submission" do
        click_link "Submissions"
        click_link incomplete_submission.app_name

        expect(page).not_to have_link("Unpublish")
      end
    end

    context "as an admin" do
      before do
        sign_in(:admin)
      end

      it "does not display a link to unpublish the submission" do
        click_link "Submissions"
        click_link incomplete_submission.app_name

        expect(page).not_to have_link("Unpublish")
      end
    end
  end
end
