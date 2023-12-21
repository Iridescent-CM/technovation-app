require "rails_helper"

RSpec.describe "admin/scores/_score_controls.html.erb", type: :view do
  before do
    render partial: "admin/scores/score_controls",
      locals: {current_account: current_account, score: score_submission}
  end

  let(:current_account) {
    instance_double(Account,
      admin?: current_account_admin)
  }
  let(:score_submission) {
    instance_double(SubmissionScore, id: 1,
      pending_approval?: score_submission_pending_approval,
      deleted?: score_submission_deleted)
  }

  let(:current_account_admin) { false }
  let(:score_submission_deleted) { false }
  let(:score_submission_pending_approval) { false }

  context "as an admin" do
    let(:current_account_admin) { true }

    context "when a score is pending approval and not deleted" do
      let(:score_submission_pending_approval) { true }
      let(:score_submission_deleted) { false }

      it "renders a button to approve the score" do
        expect(rendered).to have_button("Approve this score")
      end

      it "renders a button to delete the score" do
        expect(rendered).to have_button("Delete this score")
      end

      it "does not render a button to restore the score" do
        expect(rendered).not_to have_button("Restore this score")
      end
    end

    context "when a score is offcial/approved and is not deleted" do
      let(:score_submission_pending_approval) { false }
      let(:score_submission_deleted) { false }

      it "renders a button to delete the score" do
        expect(rendered).to have_button("Delete this score")
      end

      it "does not render a button to approve the score" do
        expect(rendered).not_to have_button("Approve this score")
      end

      it "does not render a button to restore the score" do
        expect(rendered).not_to have_button("Restore this score")
      end
    end

    context "when a score is pending approval and deleted" do
      let(:score_submission_pending_approval) { true }
      let(:score_submission_deleted) { true }

      it "renders a button to restore the score" do
        expect(rendered).to have_button("Restore this score")
      end

      it "does not render a button to approve the score" do
        expect(rendered).not_to have_button("Approve this score")
      end

      it "does not render a button to delete the score" do
        expect(rendered).not_to have_button("Delete this score")
      end
    end

    context "when a score is official/approved and deleted" do
      let(:score_submission_pending_approval) { false }
      let(:score_submission_deleted) { true }

      it "renders a button to restore the score" do
        expect(rendered).to have_button("Restore this score")
      end

      it "does not render a button to approve the score" do
        expect(rendered).not_to have_button("Approve this score")
      end

      it "does not render a button to delete the score" do
        expect(rendered).not_to have_button("Delete this score")
      end
    end
  end

  context "as a non-admin" do
    let(:current_account_admin) { false }

    it "does not render the admin score controls" do
      expect(rendered).not_to have_css("div.admin-action-buttons")
      expect(rendered).not_to have_button
    end
  end
end
