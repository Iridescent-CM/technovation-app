require "rails_helper"

RSpec.describe "admin/participants/_judge_scores.html.erb", type: :view do
  before do
    render partial: "admin/participants/judge_scores", locals: { scores: scores }
  end

  context "when a judge has scored a submission" do
    let(:scores) { [score_submission] }
    let(:score_submission) {
      instance_double(
        SubmissionScore,
        team_submission_id: 1,
        team_name: "Amazing Team",
        team_submission_app_name: "Amazing App",
        total: 99,
        total_possible: 100,
        deleted?: score_submission_deleted,
        dropped?: score_submission_dropped
      )
    }
    let(:score_submission_deleted) { false }
    let(:score_submission_dropped) { false }

    it "displays score summary information" do
      expect(rendered).to have_content("Score")
      expect(rendered).to have_content("99 / 100")
    end

    it "displays the team name" do
      expect(rendered).to have_content("Team Name")
      expect(rendered).to have_content("Amazing Team")
    end

    it "displays the team's submission name" do
      expect(rendered).to have_content("Submission Name")
      expect(rendered).to have_content("Amazing App")
    end

    it "displays displays a link to view score details" do
      expect(rendered).to have_content("Details")
      expect(rendered).to have_link("View")
    end

    describe "deleted information" do
      context "when the score is marked as deleted" do
        let(:score_submission_deleted) { true }

        it "indicates that the score has been deleted" do
          expect(rendered).to have_content("Deleted")
          expect(rendered).to have_css(".deleted-info", text: "deleted")
        end

        it "displays the the deleted information with a subtle red background color" do
          expect(rendered).to have_css(".background-color--subtle-red")
        end
      end

      context "when the score is marked as dropped" do
        let(:score_submission_deleted) { true }
        let(:score_submission_dropped) { true }

        it "indicates that the score has been dropped" do
          expect(rendered).to have_content("Deleted")
          expect(rendered).to have_css(".deleted-info", text: "dropped")
        end

        it "displays the the dropped information with a subtle red background color" do
          expect(rendered).to have_css(".background-color--subtle-red")
        end
      end

      context "when the score is not marked as deleted" do
        let(:score_submission_deleted) { false }

        it "indicates that the score has not been deleted" do
          expect(rendered).to have_content("Deleted")
          expect(rendered).to have_css(".deleted-info", text: "")
        end

        it "displays the the deleted information without a special background color" do
          expect(rendered).not_to have_css(".background-color--subtle-red")
        end
      end
    end
  end

  context "when a judge has not scored any submissions" do
    let(:scores) { [] }

    it "displays a 'no scores' message" do
      expect(rendered).to have_content("No scores")
    end
  end
end
