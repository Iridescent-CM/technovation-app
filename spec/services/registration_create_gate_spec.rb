require "rails_helper"

RSpec.describe RegistrationCreateGate do
  subject(:gate) do
    described_class.new(
      profile_type: profile_type,
      invite_code: invite_code,
      team_invite_code: team_invite_code
    ).call
  end

  let(:profile_type) { "student" }
  let(:invite_code) { nil }
  let(:team_invite_code) { nil }

  before do
    allow(SeasonToggles).to receive(:student_registration_open?).and_return(student_registration_open)
    allow(SeasonToggles).to receive(:mentor_registration_open?).and_return(mentor_registration_open)
    allow(SeasonToggles).to receive(:judge_registration_open?).and_return(judge_registration_open)
    allow(SeasonToggles).to receive(:chapter_ambassador_registration_open?).and_return(false)
    allow(SeasonToggles).to receive(:club_ambassador_registration_open?).and_return(false)
  end

  let(:student_registration_open) { true }
  let(:mentor_registration_open) { false }
  let(:judge_registration_open) { false }

  context "with an invalid profile type" do
    let(:profile_type) { "invalid" }

    it "is not valid" do
      expect(gate.valid?).to eq(false)
      expect(gate.errors).to include("Invalid profile type")
    end
  end

  context "when registration is open for the profile type" do
    it "is valid" do
      expect(gate.valid?).to eq(true)
    end
  end

  context "when registration is closed for the profile type" do
    let(:student_registration_open) { false }

    it "is not valid without an invite" do
      expect(gate.valid?).to eq(false)
      expect(gate.errors).to include("Registration is not open for this profile type")
    end

    context "with a valid matching invite" do
      let(:invite) do
        UserInvitation.create!(
          profile_type: "student",
          email: "student.invite@example.com",
          register_at_any_time: true
        )
      end
      let(:invite_code) { invite.admin_permission_token }

      it "is valid" do
        expect(gate.valid?).to eq(true)
      end
    end

    context "with a valid invite for a different profile type" do
      let(:invite) do
        UserInvitation.create!(
          profile_type: "mentor",
          email: "mentor.invite@example.com",
          register_at_any_time: true
        )
      end
      let(:invite_code) { invite.admin_permission_token }

      it "is not valid" do
        expect(gate.valid?).to eq(false)
        expect(gate.errors).to include("This invitation does not match the selected profile type")
      end
    end
  end
end
