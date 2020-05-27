require "rails_helper"

RSpec.describe StudentSubmissionLinkGuard do
  let(:submission_link_guard) { StudentSubmissionLinkGuard.new(team: team, student: student, season_toggles: season_toggles) }
  let(:team) { instance_double(Team, submission: submission) }
  let(:submission) { instance_double(TeamSubmission, complete?: submission_complete) }
  let(:student) { instance_double(StudentProfile, is_on_team?: student_on_a_team) }
  let(:season_toggles) { class_double(SeasonToggles, team_submissions_editable?: submissions_editable) }
  let(:student_on_a_team) { false }
  let(:submission_complete) { false }
  let(:submissions_editable) { false }

  describe "#display_link_to_new?" do
    context "when submissions are editable" do
      let(:submissions_editable) { true }

      context "when the student is on a team" do
        let(:student_on_a_team) { true }

        context "when the team doesn't have a submission" do
          let(:submission) { nil }

          it "returns true" do
            expect(submission_link_guard.display_link_to_new?).to eq(true)
          end
        end

        context "when the team has a submission" do
          let(:submission) { instance_double(TeamSubmission) }

          it "returns false" do
            expect(submission_link_guard.display_link_to_new?).to eq(false)
          end
        end
      end

      context "when the student isn't on a team" do
        let(:student_on_a_team) { false }

        it "returns false" do
          expect(submission_link_guard.display_link_to_new?).to eq(false)
        end
      end
    end

    context "when submissions are not editable" do
      let(:submissions_editable) { false }

      it "returns false" do
        expect(submission_link_guard.display_link_to_new?).to eq(false)
      end
    end
  end

  describe "#display_link_to_in_progress?" do
    context "when the student is on a team" do
      let(:student_on_a_team) { true }

      context "when the team has a submission, and it isn't complete" do
        let(:submission_complete) { false }

        it "returns true" do
          expect(submission_link_guard.display_link_to_in_progress?).to eq(true)
        end
      end

      context "when the team doesn't have a submission" do
        let(:submission) { nil }

        it "returns false" do
          expect(submission_link_guard.display_link_to_in_progress?).to eq(false)
        end
      end
    end

    context "when the student isn't on a team" do
      let(:student_on_a_team) { false }

      it "returns false" do
        expect(submission_link_guard.display_link_to_in_progress?).to eq(false)
      end
    end
  end

  describe "#display_link_to_published?" do
    context "when submissions are not editable" do
      let(:submissions_editable) { false }

      context "when the student is on a team" do
        let(:student_on_a_team) { true }

        context "when the team's submission is complete" do
          let(:submission_complete) { true }

          it "returns true" do
            expect(submission_link_guard.display_link_to_published?).to eq(true)
          end
        end

        context "when the team's submission is not complete" do
          let(:submission_complete) { false }

          it "returns false" do
            expect(submission_link_guard.display_link_to_published?).to eq(false)
          end
        end
      end

      context "when the sudent is not on a team" do
        let(:student_on_a_team) { true }

        it "returns false" do
          expect(submission_link_guard.display_link_to_published?).to eq(false)
        end
      end

    end

    context "when submissions are editable" do
      let(:submissions_editable) { true }

      it "returns false" do
        expect(submission_link_guard.display_link_to_published?).to eq(false)
      end
    end
  end
end
