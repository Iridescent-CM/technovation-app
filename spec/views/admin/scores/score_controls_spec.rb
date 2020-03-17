require "rails_helper"

RSpec.describe "admin/scores/score_controls", type: :view do
  before do
    render partial: "admin/scores/score_controls",
      locals: { current_account: current_account, score: score_submission }
  end

  let(:current_account) { instance_double(Account,
    admin?: current_account_admin) }
  let(:score_submission) { instance_double(SubmissionScore, id: 1,
    pending_approval?: score_submission_pending_approval) }

  let(:current_account_admin) { false }
  let(:score_submission_pending_approval) { false }

  context "as an admin" do
    let(:current_account_admin) { true }

    it "renders a button to delete the score" do
      expect(rendered).to have_button("Delete this score")
    end

    context "when the score is pending approval" do
      let(:score_submission_pending_approval) { true }

      it "renders a button to approve the score" do
        expect(rendered).to have_button("Approve this score")
      end
    end

    context "when the score is not pending approval" do
      let(:score_submission_pending_approval) { false }

      it "does not render a button to approve the score" do
        expect(rendered).not_to have_button("Approve this score")
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
