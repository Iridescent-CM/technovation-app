require "rails_helper"

describe TeamInviteCodeValidator do
  let(:team_invite_code_validator) {
    TeamInviteCodeValidator.new(team_invite_code: team_invite_code, important_dates: important_dates)
  }
  let(:team_invite_code) { "987zyxw654tsrq321" }
  let(:important_dates) {
    class_double("ImportantDates",
      official_start_of_season: official_start_of_season,
      submission_deadline: submission_deadline)
  }

  let(:official_start_of_season) { Date.parse("2020-10-01") }
  let(:submission_deadline) { Date.parse("2021-04-15") }

  before do
    allow(TeamMemberInvite).to receive(:find_by)
      .with(invite_token: team_invite_code)
      .and_return(invitation)
  end

  let(:invitation) do
    instance_double(TeamMemberInvite,
      pending?: pending_invite,
      inviter_type: inviter_profile_type,
      invitee_type: invitee_profile_type)
  end

  let(:pending_invite) { false }
  let(:inviter_profile_type) { "StudentProfile" }
  let(:invitee_profile_type) { "StudentProfile" }

  context "when a team invite is pending" do
    let(:pending_invite) { true }

    context "when a student made the invite" do
      let(:inviter_profile_type) { "StudentProfile" }

      context "when today's date is between the official start of season and the submission deadline" do
        before do
          Timecop.freeze(Date.parse("2020-11-17"))
        end

        after do
          Timecop.return
        end

        it "is valid" do
          expect(team_invite_code_validator.call.valid?).to eq(true)
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
  end

  context "when a team invite is not pending" do
    let(:pending_invite) { false }

    it "is not valid" do
      expect(team_invite_code_validator.call.valid?).to eq(false)
    end
  end

  context "when a mentor made the invite" do
    let(:inviter_profile_type) { "MentorProfile" }

    it "is not valid" do
      expect(team_invite_code_validator.call.valid?).to eq(false)
    end
  end

  context "when today's date is after the submission deadline" do
    before do
      Timecop.freeze(Date.parse("2021-04-30"))
    end

    after do
      Timecop.return
    end

    it "is not valid" do
      expect(team_invite_code_validator.call.valid?).to eq(false)
    end
  end
end
