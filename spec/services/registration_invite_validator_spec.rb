require "rails_helper"

describe RegistrationInviteValidator do
  let(:registration_invite_validator) {
    RegistrationInviteValidator.new(invite_code: invite_code)
  }
  let(:invite_code) { "12345abcde9876zyxw" }

  before do
    allow(UserInvitation).to receive(:find_by)
      .with(admin_permission_token: invite_code)
      .and_return(invitation)

    allow(SeasonToggles).to receive(:student_registration_open?).and_return(student_registration_open)
    allow(SeasonToggles).to receive(:mentor_registration_open?).and_return(mentor_registration_open)
    allow(SeasonToggles).to receive(:judge_registration_open?).and_return(judge_registration_open)
  end

  let(:student_registration_open) { false }
  let(:mentor_registration_open) { false }
  let(:judge_registration_open) { false }

  let(:invitation) do
    instance_double(UserInvitation,
      pending?: pending_invite,
      student?: student_invite,
      mentor?: mentor_invite,
      judge?: judge_invite,
      chapter_ambassador?: chapter_ambassador_invite)
  end

  let(:pending_invite) { false }
  let(:student_invite) { false }
  let(:mentor_invite) { false }
  let(:judge_invite) { false }
  let(:chapter_ambassador_invite) { false }

  context "when an invite is pending" do
    let(:pending_invite) { true }

    context "when the invite is for a student" do
      let(:student_invite) { true }

      context "when student registration is open" do
        let(:student_registration_open) { true }

        it "is valid" do
          expect(registration_invite_validator.call.valid?).to eq(true)
        end

        it "sets the profile type to 'student'" do
          expect(registration_invite_validator.call.profile_type).to eq("student")
        end

        it "sets the friendly profile type to 'student'" do
          expect(registration_invite_validator.call.friendly_profile_type).to eq("student")
        end
      end

      context "when student registration is closed" do
        let(:student_registration_open) { false }

        it "is not valid" do
          expect(registration_invite_validator.call.valid?).to eq(false)
        end
      end
    end

    context "when the invite is for a mentor" do
      let(:mentor_invite) { true }

      context "when mentor registration is open" do
        let(:mentor_registration_open) { true }

        it "is valid" do
          expect(registration_invite_validator.call.valid?).to eq(true)
        end

        it "sets the profile type to 'mentor'" do
          expect(registration_invite_validator.call.profile_type).to eq("mentor")
        end

        it "sets the friendly profile type to 'mentor'" do
          expect(registration_invite_validator.call.friendly_profile_type).to eq("mentor")
        end
      end

      context "when mentor registration is closed" do
        let(:mentor_registration_open) { false }

        it "is not valid" do
          expect(registration_invite_validator.call.valid?).to eq(false)
        end
      end
    end

    context "when the invite is for a judge" do
      let(:judge_invite) { true }

      context "when judge registration is open" do
        let(:judge_registration_open) { true }

        it "is valid" do
          expect(registration_invite_validator.call.valid?).to eq(true)
        end

        it "sets the profile type to 'judge'" do
          expect(registration_invite_validator.call.profile_type).to eq("judge")
        end

        it "sets the friendly profile type to 'judge'" do
          expect(registration_invite_validator.call.friendly_profile_type).to eq("judge")
        end
      end

      context "when judge registration is closed" do
        let(:judge_registration_open) { false }

        it "is not valid" do
          expect(registration_invite_validator.call.valid?).to eq(false)
        end
      end
    end

    context "when the invite is for a chapter ambassador" do
      let(:chapter_ambassador_invite) { true }

      it "is valid" do
        expect(registration_invite_validator.call.valid?).to eq(true)
      end

      it "sets the profile type to 'chapter_ambassador'" do
        expect(registration_invite_validator.call.profile_type).to eq("chapter_ambassador")
      end

      it "sets the friendly profile type to 'chapter ambassador'" do
        expect(registration_invite_validator.call.friendly_profile_type).to eq("chapter ambassador")
      end
    end
  end

  context "when the invite is not pending" do
    let(:pending_invite) { false }

    it "is valid" do
      expect(registration_invite_validator.call.valid?).to eq(false)
    end
  end
end
