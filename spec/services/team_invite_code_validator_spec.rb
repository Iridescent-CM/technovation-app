require "rails_helper"

describe TeamInviteCodeValidator do
  let(:team_invite_code_validator) {
    TeamInviteCodeValidator.new(team_invite_code: team_invite_code)
  }
  let(:team_invite_code) { "987zyxw654tsrq321" }

  before do
    allow(TeamMemberInvite).to receive(:find_by)
      .with(invite_token: team_invite_code)
      .and_return(invitation)

    allow(SeasonToggles).to receive(:team_building_enabled?).and_return(team_building_enabled)
  end

  let(:team_building_enabled) { false }

  let(:invitation) do
    instance_double(TeamMemberInvite,
      pending?: pending_invite,
      inviter_type: inviter_profile_type,
      invitee_type: invitee_profile_type,
      team_name: "ABCool Team")
  end

  let(:pending_invite) { false }
  let(:inviter_profile_type) { "StudentProfile" }
  let(:invitee_profile_type) { "StudentProfile" }

  context "when a team invite is pending" do
    let(:pending_invite) { true }

    context "when a student made the invite" do
      let(:inviter_profile_type) { "StudentProfile" }

      context "when team building is enabled" do
        let(:team_building_enabled) { true }

        it "is valid" do
          expect(team_invite_code_validator.call.valid?).to eq(true)
        end

        it "returns a success message" do
          expect(team_invite_code_validator.call.success_message).to eq('You have been invited to join the team "ABCool Team"!')
        end

        context "when the invite is for a student" do
          let(:invitee_profile_type) { "StudentProfile" }

          it "returns 'student' for the registration profile type" do
            expect(team_invite_code_validator.call.registration_profile_type).to eq("student")
          end
        end

        context "when the invite is for a mentor" do
          let(:invitee_profile_type) { "MentorProfile" }

          it "returns 'mentor' for the registration profile type" do
            expect(team_invite_code_validator.call.registration_profile_type).to eq("mentor")
          end

          it "returns a success message mentioning they've been invited to join as a mentor" do
            expect(team_invite_code_validator.call.success_message).to eq('You have been invited to join the team "ABCool Team" as a mentor!')
          end
        end
      end
    end
  end

  context "when an invite doesn't exist for the provided team invite code" do
    before do
      allow(TeamMemberInvite).to receive(:find_by)
        .with(invite_token: team_invite_code)
        .and_return(nil)
    end

    it "is not valid" do
      expect(team_invite_code_validator.call.valid?).to eq(false)
    end

    it "returns an error message" do
      expect(team_invite_code_validator.call.error_message).to eq("This invite is no longer valid.")
    end
  end

  context "when a team invite is not pending" do
    let(:pending_invite) { false }

    it "is not valid" do
      expect(team_invite_code_validator.call.valid?).to eq(false)
    end

    it "returns an error message" do
      expect(team_invite_code_validator.call.error_message).to eq("This invite is no longer valid.")
    end
  end

  context "when a mentor made the invite" do
    let(:inviter_profile_type) { "MentorProfile" }

    it "is not valid" do
      expect(team_invite_code_validator.call.valid?).to eq(false)
    end

    it "returns an error message" do
      expect(team_invite_code_validator.call.error_message).to eq("This invite is no longer valid.")
    end
  end

  context "when team building is disabled" do
    let(:team_building_enabled) { false }

    it "is not valid" do
      expect(team_invite_code_validator.call.valid?).to eq(false)
    end

    it "returns an error message" do
      expect(team_invite_code_validator.call.error_message).to eq("This invite is no longer valid.")
    end
  end
end
