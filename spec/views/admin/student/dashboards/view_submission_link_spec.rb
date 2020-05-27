require "rails_helper"

RSpec.describe "student/dashboards/view_submission_link", type: :view do
  before do
    allow(StudentSubmissionLinkGuard).to receive(:new).with(team: team, student: student).and_return(submission_link_guard)

    render partial: "student/dashboards/view_submission_link",
      locals: { current_team: team, current_student: student }
  end

  let(:submission_link_guard) { instance_double(StudentSubmissionLinkGuard, display_link_to_published?: display_link_to_published) }
  let(:display_link_to_published) { false }
  let(:team) { instance_double(Team, submission: instance_double(TeamSubmission)) }
  let(:student) { instance_double(StudentProfile) }

  context "when #display_link_to_published? returns true" do
    let(:display_link_to_published) { true }

    it "renders a link to view the team's published submission" do
      expect(rendered).to have_link("View my team's submission")
      expect(rendered).to include("/published_team_submissions")
    end
  end

  context "when #display_link_to_published? returns false" do
    let(:display_link_to_published) { false }

    it "does not render a link to view the team's published submission" do
      expect(rendered).not_to have_link("View my team's submission")
      expect(rendered).not_to include("/published_team_submissions")
    end
  end
end
