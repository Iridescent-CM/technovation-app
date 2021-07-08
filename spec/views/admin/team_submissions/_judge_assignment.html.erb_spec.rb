require "rails_helper"

RSpec.describe "admin/team_submissions/_judge_assignment.html.erb", type: :view do
  before do
    SeasonToggles.set_judging_round(judging_round)

    render partial: "admin/team_submissions/judge_assignment",
      locals: { current_profile: current_profile, submission: submission }
  end

  let(:judging_round) { :off }
  let(:current_profile) { instance_double(Account, admin?: admin) }
  let(:submission) { instance_double(TeamSubmission) }
  let(:admin) { false }

  context "as an admin" do
    let(:admin) { true }

    context "when judging is enabled" do
      let(:judging_round) { :qf }

      it "renders the partial to assign a judge to a submisison" do
        expect(rendered).to include("Assign Judge to Submission")
      end
    end

    context "when judging is not enabled" do
      let(:judging_round) { :off }

      it "does not render the partial to assign a judge to a submisison" do
        expect(rendered).to be_blank
      end
    end
  end

  context "as a non-admin" do
    let(:admin) { false }

    context "when judging is enabled" do
      let(:judging_round) { :qf }

      it "does not render the partial to assign a judge to a submisison" do
        expect(rendered).to be_blank
      end
    end

    context "when judging is not enabled" do
      let(:judging_round) { :off }

      it "does not render the partial to assign a judge to a submisison" do
        expect(rendered).to be_blank
      end
    end
  end
end
