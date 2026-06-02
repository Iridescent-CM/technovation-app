require "rails_helper"

RSpec.describe "ambassador/score_details/_scores_table.html.erb", type: :view do
  before do
    allow(view).to receive(:chapter_ambassador_can_link_to_judge?)
      .with(score: score_submission, account: current_account)
      .and_return(can_link_to_judge)

    render partial: "ambassador/score_details/scores_table",
      locals: {scores: scores, current_account: current_account, current_scope: current_scope}
  end

  let(:scores) { [score_submission] }
  let(:score_submission) {
    instance_double(
      SubmissionScore,
      id: 1,
      team_submission_id: 22,
      team_name: "Dream Team",
      team_submission_app_name: "Dreamy App",
      judge_name: "Judge Dredd",
      judge_profile: double(
        "judge_profile",
        id: 333,
        account_id: 333,
        account: double("judge_account", first_name: "Judge", last_name: "Dredd")
      ),
      total: 75,
      total_possible: 80,
      official?: score_submission_offical,
      deleted?: score_submission_deleted,
      dropped?: score_submission_dropped
    )
  }
  let(:score_submission_offical) { false }
  let(:score_submission_deleted) { false }
  let(:score_submission_dropped) { false }

  let(:current_account) {
    instance_double(Account,
      admin?: current_account_admin,
      chapter_ambassador_profile: chapter_ambassador_profile)
  }
  let(:current_account_admin) { false }
  let(:chapter_ambassador_profile) { double("chapter_ambassador_profile") }
  let(:can_link_to_judge) { true }

  let(:current_scope) { "chapter_ambassador" }

  context "as a non-admin" do
    let(:current_account_admin) { false }
    let(:current_scope) { "chapter_ambassador" }

    it "displays the score for the submisison and grand total score" do
      expect(rendered).to have_content("75 / 80")
    end

    it "displays the masked judge name" do
      expect(rendered).to have_content("Judge D.")
      expect(rendered).not_to have_content("Judge Dredd")
    end

    it "displays a link to the judge when they are chapter-connected" do
      expect(rendered).to have_link("Judge D.")
    end

    context "when the judge is not chapter-connected" do
      let(:can_link_to_judge) { false }

      it "does not display a link to the judge" do
        expect(rendered).to have_content("Judge D.")
        expect(rendered).not_to have_link("Judge D.")
      end
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
    let(:chapter_ambassador_profile) { nil }
    let(:current_scope) { "admin" }

    it "displays the full judge name and link" do
      expect(rendered).to have_link("Judge Dredd")
      expect(rendered).not_to have_content("Judge D.")
    end

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

    context "when a score is marked as dropped" do
      let(:score_submission_deleted) { true }
      let(:score_submission_dropped) { true }

      it "displays 'dropped'" do
        within ".deleted-info" do
          expect(rendered).to have_content("dropped")
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
