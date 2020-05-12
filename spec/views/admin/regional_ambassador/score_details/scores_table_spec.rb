require "rails_helper"

RSpec.describe "regional_ambassador/score_details/scores_table", type: :view do
  before do
    render partial: "regional_ambassador/score_details/scores_table",
      locals: { scores: scores, current_account: current_account, current_scope: current_scope }
  end

  let(:scores) { [score_submission] }
  let(:score_submission) { instance_double(SubmissionScore,
    id: 1,
    team_submission_id: 22,
    team_name: "Dream Team",
    team_submission_app_name: "Dreamy App",
    judge_name: "Judge Dredd",
    judge_profile: double("judge_profile", account_id: 333),
    total: 75,
    total_possible: 80,
    official?: score_submission_offical,
    deleted?: score_submission_deleted) }
  let(:score_submission_offical) { false }
  let(:score_submission_deleted) { false }

  let(:current_account) { instance_double(Account,
    admin?: current_account_admin) }
  let(:current_account_admin) { false }

  let(:current_scope) { "regional_ambassador" }

  context "as a non-admin" do
    let(:current_account_admin) { false }
    let(:current_scope) { "regional_ambassador" }

    it "displays the score for the submisison and grand total score" do
      expect(rendered).to have_content("75 / 80")
    end

    it "displays a link to the judge who scored the submission" do
      expect(rendered).to have_link("Judge Dredd")
    end

    context "when a score is offical" do
      let(:score_submission_offical) { true }

      it "displays 'offical'" do
        within ".official-info" do
          expect(rendered).to have_content("official")
        end
      end
    end

    context "when a score is unoffical" do
      let(:score_submission_offical) { false }

      it "displays 'unofficial'" do
        within ".official-info" do
          expect(rendered).to have_content("unofficial")
        end
      end
    end

    it "displays a link to view the score details" do
      expect(rendered).to have_link("View score")
    end

    it "does not display deleted scores" do
      expect(rendered).not_to have_css(".deleted-info")
    end
  end

  context "as an admin" do
    let(:current_account_admin) { true }
    let(:current_scope) { "admin" }

    context "when a score is marked as deleted" do
      let(:score_submission_deleted) { true }

      it "displays 'deleted'" do
        within ".deleted-info" do
          expect(rendered).to have_content("deleted")
        end
      end

      it "displays the row in a subtle red color" do
        within "tr" do
          expect(rendered).to have_css(".background-color--subtle-red")
        end
      end
    end

    context "when a score is not marked as deleted" do
      let(:score_submission_deleted) { false }

      it "does not display 'deleted'" do
        within ".deleted-info" do
          expect(rendered).not_to have_content("deleted")
        end
      end

      it "does not displays the row in a subtle red color" do
        within "tr" do
          expect(rendered).not_to have_css(".background-color--subtle-red")
        end
      end
    end
  end

  context "when there are no scores to display" do
    let(:scores) { [] }

    it "displays a no scores message" do
      expect(rendered).to have_content("No scores")
    end
  end
end
