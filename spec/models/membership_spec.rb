require "rails_helper"

RSpec.describe Membership do
  context "callbacks" do
    describe "#after_commit" do
      context "when the membership is for a mentor" do
        let(:mentor_profile) { FactoryBot.create(:mentor) }
        let(:member_type) { "MentorProfile" }
        let(:team) { FactoryBot.create(:team) }

        it "calls the job to update the mentor's program info in the CRM" do
          expect(CRM::UpdateProgramInfoJob).to receive(:perform_later)

          Membership.create(
            member_type: member_type,
            member_id: mentor_profile.id,
            team_id: team.id
          )
        end
      end

      context "when the membership is for a student" do
        let(:student_profile) { FactoryBot.create(:student) }
        let(:member_type) { "StudentProfile" }
        let(:team) { FactoryBot.create(:team) }

        it "does not call the job to update the mentor's program info in the CRM" do
          expect(CRM::UpdateProgramInfoJob).not_to receive(:perform_later)

          Membership.create(
            member_type: member_type,
            member_id: student_profile.id,
            team_id: team.id
          )
        end
      end
    end
  end
end
