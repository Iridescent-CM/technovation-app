require "rails_helper"

describe RegistrationInviteCodeValidator do
  let(:registration_invite_code_validator) {
    RegistrationInviteCodeValidator.new(invite_code: invite_code)
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
      parent_student?: parent_student_invite,
      mentor?: mentor_invite,
      judge?: judge_invite,
      chapter_ambassador?: chapter_ambassador_invite,
      club_ambassador?: club_ambassador_invite,
      register_at_any_time?: register_at_any_time)
  end

  let(:pending_invite) { false }
  let(:student_invite) { false }
  let(:parent_student_invite) { false }
  let(:mentor_invite) { false }
  let(:judge_invite) { false }
  let(:chapter_ambassador_invite) { false }
  let(:club_ambassador_invite) { false }
  let(:register_at_any_time) { false }

  context "when an invite is pending" do
    let(:pending_invite) { true }

    context "when the invite is for a student" do
      let(:student_invite) { true }

      context "when student registration is open" do
        let(:student_registration_open) { true }

        it "is valid" do
          expect(registration_invite_code_validator.call.valid?).to eq(true)
        end

        it "sets the registration profile type to 'student'" do
          expect(registration_invite_code_validator.call.registration_profile_type).to eq("student")
        end

        it "sets a success message" do
          expect(registration_invite_code_validator.call.success_message).to eq("You have been invited to join Technovation Girls as a student!")
        end
      end

      context "when student registration is closed" do
        let(:student_registration_open) { false }

        it "is not valid" do
          expect(registration_invite_code_validator.call.valid?).to eq(false)
        end

        it "sets an error message" do
          expect(registration_invite_code_validator.call.error_message).to eq("This invitation is no longer valid.")
        end

        context "when an invite can be used at any time" do
          let(:register_at_any_time) { true }

          it "is valid" do
            expect(registration_invite_code_validator.call.valid?).to eq(true)
          end

          it "sets the registration profile type to 'student'" do
            expect(registration_invite_code_validator.call.registration_profile_type).to eq("student")
          end

          it "sets a success message" do
            expect(registration_invite_code_validator.call.success_message).to eq("You have been invited to join Technovation Girls as a student!")
          end
        end
      end
    end

    context "when the invite is for a parent/beginner student" do
      let(:parent_student_invite) { true }

      context "when student registration is open" do
        let(:student_registration_open) { true }

        it "is valid" do
          expect(registration_invite_code_validator.call.valid?).to eq(true)
        end

        it "sets the registration profile type to 'parent'" do
          expect(registration_invite_code_validator.call.registration_profile_type).to eq("parent")
        end

        it "sets a success message" do
          expect(registration_invite_code_validator.call.success_message).to eq("You have been invited to join Technovation Girls as a parent!")
        end
      end

      context "when student registration is closed" do
        let(:student_registration_open) { false }

        it "is not valid" do
          expect(registration_invite_code_validator.call.valid?).to eq(false)
        end

        it "sets an error message" do
          expect(registration_invite_code_validator.call.error_message).to eq("This invitation is no longer valid.")
        end

        context "when an invite can be used at any time" do
          let(:register_at_any_time) { true }

          it "is valid" do
            expect(registration_invite_code_validator.call.valid?).to eq(true)
          end

          it "sets the registration profile type to 'parent'" do
            expect(registration_invite_code_validator.call.registration_profile_type).to eq("parent")
          end

          it "sets a success message" do
            expect(registration_invite_code_validator.call.success_message).to eq("You have been invited to join Technovation Girls as a parent!")
          end
        end
      end
    end

    context "when the invite is for a mentor" do
      let(:mentor_invite) { true }

      context "when mentor registration is open" do
        let(:mentor_registration_open) { true }

        it "is valid" do
          expect(registration_invite_code_validator.call.valid?).to eq(true)
        end

        it "sets the registration profile type to 'mentor'" do
          expect(registration_invite_code_validator.call.registration_profile_type).to eq("mentor")
        end

        it "sets a success message" do
          expect(registration_invite_code_validator.call.success_message).to eq("You have been invited to join Technovation Girls as a mentor!")
        end
      end

      context "when mentor registration is closed" do
        let(:mentor_registration_open) { false }

        it "is not valid" do
          expect(registration_invite_code_validator.call.valid?).to eq(false)
        end

        it "sets an error message" do
          expect(registration_invite_code_validator.call.error_message).to eq("This invitation is no longer valid.")
        end

        context "when an invite can be used at any time" do
          let(:register_at_any_time) { true }

          it "is valid" do
            expect(registration_invite_code_validator.call.valid?).to eq(true)
          end

          it "sets the registration profile type to 'mentor'" do
            expect(registration_invite_code_validator.call.registration_profile_type).to eq("mentor")
          end

          it "sets a success message" do
            expect(registration_invite_code_validator.call.success_message).to eq("You have been invited to join Technovation Girls as a mentor!")
          end
        end
      end
    end

    context "when the invite is for a judge" do
      let(:judge_invite) { true }

      context "when judge registration is open" do
        let(:judge_registration_open) { true }

        it "is valid" do
          expect(registration_invite_code_validator.call.valid?).to eq(true)
        end

        it "sets the registration profile type to 'judge'" do
          expect(registration_invite_code_validator.call.registration_profile_type).to eq("judge")
        end

        it "sets a success message" do
          expect(registration_invite_code_validator.call.success_message).to eq("You have been invited to join Technovation Girls as a judge!")
        end
      end

      context "when judge registration is closed" do
        let(:judge_registration_open) { false }

        it "is not valid" do
          expect(registration_invite_code_validator.call.valid?).to eq(false)
        end

        it "sets an error message" do
          expect(registration_invite_code_validator.call.error_message).to eq("This invitation is no longer valid.")
        end

        context "when an invite can be used at any time" do
          let(:register_at_any_time) { true }

          it "is valid" do
            expect(registration_invite_code_validator.call.valid?).to eq(true)
          end

          it "sets the registration profile type to 'judge'" do
            expect(registration_invite_code_validator.call.registration_profile_type).to eq("judge")
          end

          it "sets a success message" do
            expect(registration_invite_code_validator.call.success_message).to eq("You have been invited to join Technovation Girls as a judge!")
          end
        end
      end
    end

    context "when the invite is for a chapter ambassador" do
      let(:chapter_ambassador_invite) { true }

      it "is valid" do
        expect(registration_invite_code_validator.call.valid?).to eq(true)
      end

      it "sets the registration profile type to 'chapter_ambassador'" do
        expect(registration_invite_code_validator.call.registration_profile_type).to eq("chapter_ambassador")
      end

      it "sets a success message" do
        expect(registration_invite_code_validator.call.success_message).to eq("You have been invited to join Technovation Girls as a chapter ambassador!")
      end
    end
  end

  context "when the invite is not pending" do
    let(:pending_invite) { false }

    it "is is not valid" do
      expect(registration_invite_code_validator.call.valid?).to eq(false)
    end

    it "sets an error message" do
      expect(registration_invite_code_validator.call.error_message).to eq("This invitation is no longer valid.")
    end
  end
end
