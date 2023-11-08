require "rails_helper"

describe RegistrationSettingsAggregator do
  let(:registration_settings_aggregator) {
    RegistrationSettingsAggregator.new(
      invite_code: invite_code,
      invite_code_validator: invite_code_validator,
      team_invite_code: team_invite_code,
      team_invite_code_validator: team_invite_code_validator,
      season_toggles: season_toggles
    )
  }

  let(:invite_code) { "" }
  let(:invite_code_validator) {
    class_double(RegistrationInviteCodeValidator)
  }

  before do
    allow(invite_code_validator).to receive(:new)
      .with(invite_code: invite_code)
      .and_return(invite_code_validator_instance)
  end

  let(:invite_code_validator_instance) {
    instance_double(RegistrationInviteCodeValidator, call: invite_code_validator_response)
  }
  let(:invite_code_validator_response) {
    double("invite_code_validator_response",
      valid?: invite_code_valid,
      register_at_any_time?: register_at_any_time,
      registration_profile_type: invite_profile_type,
      success_message: invite_success_message,
      error_message: invite_error_message)
  }
  let(:invite_code_valid) { false }
  let(:register_at_any_time) { false }
  let(:invite_profile_type) { "student" }
  let(:invite_success_message) { "This invite is valid." }
  let(:invite_error_message) { "This invite is not valid." }

  let(:team_invite_code) { "" }
  let(:team_invite_code_validator) {
    class_double(TeamInviteCodeValidator)
  }

  before do
    allow(team_invite_code_validator).to receive(:new)
      .with(team_invite_code: team_invite_code)
      .and_return(team_invite_code_validator_instance)
  end

  let(:team_invite_code_validator_instance) {
    instance_double(TeamInviteCodeValidator, call: team_invite_code_validator_response)
  }
  let(:team_invite_code_validator_response) {
    double("invite_code_validator_response",
      valid?: team_invite_code_valid,
      registration_profile_type: team_invite_profile_type,
      success_message: team_invite_success_message,
      error_message: team_invite_error_message)
  }
  let(:team_invite_code_valid) { false }
  let(:team_invite_profile_type) { "student" }
  let(:team_invite_success_message) { "This team invite is valid." }
  let(:team_invite_error_message) { "This team invite is not valid." }

  let(:season_toggles) {
    class_double(SeasonToggles,
      student_registration_open?: student_registration_open,
      mentor_registration_open?: mentor_registration_open,
      judge_registration_open?: judge_registration_open)
  }
  let(:student_registration_open) { true }
  let(:mentor_registration_open) { true }
  let(:judge_registration_open) { true }

  context "when there isn't an invite code or team invite code" do
    let(:invite_code) { nil }
    let(:team_invite_code) { nil }

    it "sets the student registration setting to the SeasonToggles student registration setting" do
      expect(registration_settings_aggregator.call.student_registration_open?).to eq(season_toggles.student_registration_open?)
    end

    it "sets the parent registration setting to the SeasonToggles student registration setting" do
      expect(registration_settings_aggregator.call.parent_registration_open?).to eq(season_toggles.student_registration_open?)
    end

    it "sets the mentor registration setting to the SeasonToggles mentor registration setting" do
      expect(registration_settings_aggregator.call.mentor_registration_open?).to eq(season_toggles.mentor_registration_open?)
    end

    it "sets the judge registration setting to the SeasonToggles judge registration setting" do
      expect(registration_settings_aggregator.call.judge_registration_open?).to eq(season_toggles.judge_registration_open?)
    end

    it "sets chapter ambassador registration setting as false" do
      expect(registration_settings_aggregator.call.chapter_ambassador_registration_open?).to eq(false)
    end

    context "when there are registration types that are closed" do
      let(:student_registration_open) { false }
      let(:mentor_registration_open) { false }

      it "sets an error message mentioning the closed registration types" do
        expect(registration_settings_aggregator.call.error_message).to eq("Registration is currently closed for students and mentors.")
      end
    end
  end

  context "when there an invite code" do
    let(:invite_code) { "xyz-some-invite-code" }

    context "when the invite is for a student" do
      let(:registration_profile_type) { "student" }

      context "when student registration is open" do
        let(:student_registration_open) { true }

        context "when the invite code is valid" do
          let(:invite_code_valid) { true }

          context "when the invite code can be used at anytime" do
            let(:register_at_any_time) { true }

            it "opens registration for students" do
              expect(registration_settings_aggregator.call.student_registration_open?).to eq(true)
            end

            it "sets the invited registration profile type to the one returned by the RegistrationInviteCodeValidator" do
              expect(registration_settings_aggregator.call.invited_registration_profile_type).to eq(invite_code_validator_response.registration_profile_type)
            end

            it "sets the success message to the message returned by RegistrationInviteCodeValidator" do
              expect(registration_settings_aggregator.call.success_message).to eq(invite_code_validator_response.success_message)
            end

            it "does not set an error message" do
              expect(registration_settings_aggregator.call.error_message).to be_blank
            end
          end
        end

        context "when student registration is closed (making the invite invalid)" do
          let(:student_registration_open) { false }
          let(:invite_code_valid) { false }

          it "closes registration for students" do
            expect(registration_settings_aggregator.call.student_registration_open?).to eq(false)
          end

          context "when another registration type is open" do
            let(:mentor_registration_open) { true }

            it "sets an error message indicating that the invite is invalid, but registration is still open" do
              expect(registration_settings_aggregator.call.error_message).to include("Sorry, this invitation is no longer valid, but you can still join Technovation")
            end
          end

          context "when all registration types are closed" do
            let(:student_registration_open) { false }
            let(:mentor_registration_open) { false }
            let(:judge_registration_open) { false }

            it "sets the error message to the message returned by RegistrationInviteCodeValidator" do
              expect(registration_settings_aggregator.call.error_message).to eq(invite_code_validator_response.error_message)
            end
          end
        end
      end
    end

    context "when the invite is for a mentor" do
      let(:registration_profile_type) { "mentor" }

      context "when mentor registration is open" do
        let(:mentor_registration_open) { true }

        context "when the invite code is valid" do
          let(:invite_code_valid) { true }

          context "when the invite code can be used at anytime" do
            let(:register_at_any_time) { true }

            it "opens registration for mentors" do
              expect(registration_settings_aggregator.call.mentor_registration_open?).to eq(true)
            end

            it "sets the invited registration profile type to the one returned by the RegistrationInviteCodeValidator" do
              expect(registration_settings_aggregator.call.invited_registration_profile_type).to eq(invite_code_validator_response.registration_profile_type)
            end

            it "sets the success message to the message returned by RegistrationInviteCodeValidator" do
              expect(registration_settings_aggregator.call.success_message).to eq(invite_code_validator_response.success_message)
            end

            it "does not set an error message" do
              expect(registration_settings_aggregator.call.error_message).to be_blank
            end
          end
        end

        context "when mentor registration is closed (making the invite invalid)" do
          let(:mentor_registration_open) { false }
          let(:invite_code_valid) { false }

          it "closes registration for mentors" do
            expect(registration_settings_aggregator.call.mentor_registration_open?).to eq(false)
          end

          context "when another registration type is open" do
            let(:mentor_registration_open) { true }

            it "sets an error message indicating that the invite is invalid, but registration is still open" do
              expect(registration_settings_aggregator.call.error_message).to include("Sorry, this invitation is no longer valid, but you can still join Technovation")
            end
          end

          context "when all registration types are closed" do
            let(:student_registration_open) { false }
            let(:mentor_registration_open) { false }
            let(:judge_registration_open) { false }

            it "sets the error message to the message returned by RegistrationInviteCodeValidator" do
              expect(registration_settings_aggregator.call.error_message).to eq(invite_code_validator_response.error_message)
            end
          end
        end
      end
    end

    context "when the invite is for a judge" do
      let(:registration_profile_type) { "judge" }

      context "when judge registration is open" do
        let(:judge_registration_open) { true }

        context "when the invite code is valid" do
          let(:invite_code_valid) { true }

          context "when the invite code can be used at anytime" do
            let(:register_at_any_time) { true }

            it "opens registration for judges" do
              expect(registration_settings_aggregator.call.judge_registration_open?).to eq(true)
            end

            it "sets the invited registration profile type to the one returned by the RegistrationInviteCodeValidator" do
              expect(registration_settings_aggregator.call.invited_registration_profile_type).to eq(invite_code_validator_response.registration_profile_type)
            end

            it "sets the success message to the message returned by RegistrationInviteCodeValidator" do
              expect(registration_settings_aggregator.call.success_message).to eq(invite_code_validator_response.success_message)
            end

            it "does not set an error message" do
              expect(registration_settings_aggregator.call.error_message).to be_blank
            end
          end
        end

        context "when judge registration is closed (making the invite invalid)" do
          let(:judge_registration_open) { false }
          let(:invite_code_valid) { false }

          it "closes registration for judges" do
            expect(registration_settings_aggregator.call.judge_registration_open?).to eq(false)
          end

          context "when another registration type is open" do
            let(:judge_registration_open) { true }

            it "sets an error message indicating that the invite is invalid, but registration is still open" do
              expect(registration_settings_aggregator.call.error_message).to include("Sorry, this invitation is no longer valid, but you can still join Technovation")
            end
          end

          context "when all registration types are closed" do
            let(:student_registration_open) { false }
            let(:mentor_registration_open) { false }
            let(:judge_registration_open) { false }

            it "sets the error message to the message returned by RegistrationInviteCodeValidator" do
              expect(registration_settings_aggregator.call.error_message).to eq(invite_code_validator_response.error_message)
            end
          end
        end
      end
    end

    context "when the invite is for a chapter ambassador" do
      let(:registration_profile_type) { "chapter_ambassador" }

      context "when the invite code is valid" do
        let(:invite_code_valid) { true }

        context "when the invite code can be used at anytime" do
          let(:register_at_any_time) { true }

          it "opens registration for chapter ambassadors" do
            expect(registration_settings_aggregator.call.judge_registration_open?).to eq(true)
          end

          it "sets the invited registration profile type to the one returned by the RegistrationInviteCodeValidator" do
            expect(registration_settings_aggregator.call.invited_registration_profile_type).to eq(invite_code_validator_response.registration_profile_type)
          end

          it "sets the success message to the message returned by RegistrationInviteCodeValidator" do
            expect(registration_settings_aggregator.call.success_message).to eq(invite_code_validator_response.success_message)
          end

          it "does not set an error message" do
            expect(registration_settings_aggregator.call.error_message).to be_blank
          end
        end
      end

      context "when the invite code is invalid" do
        let(:invite_code_valid) { false }

        context "when another registration type is open" do
          let(:judge_registration_open) { true }

          it "sets an error message indicating that the invite is invalid, but registration is still open" do
            expect(registration_settings_aggregator.call.error_message).to include("Sorry, this invitation is no longer valid, but you can still join Technovation")
        end
        end

        context "when all registration types are closed" do
          let(:student_registration_open) { false }
          let(:mentor_registration_open) { false }
          let(:judge_registration_open) { false }

          it "sets the error message to the message returned by RegistrationInviteCodeValidator" do
            expect(registration_settings_aggregator.call.error_message).to eq(invite_code_validator_response.error_message)
          end
        end
      end
    end
  end

  context "when there a team invite code" do
    let(:team_invite_code) { "987-some-team-invite-code-321" }

    context "when the invite is for a student" do
      let(:registration_profile_type) { "student" }

      context "when student registration is open" do
        let(:student_registration_open) { true }

        context "when the team invite is valid" do
          let(:team_invite_code_valid) { true }

          it "opens registration for students" do
            expect(registration_settings_aggregator.call.student_registration_open?).to eq(true)
          end

          it "opens registration for parents" do
            expect(registration_settings_aggregator.call.parent_registration_open?).to eq(true)
          end

          it "sets the success message to the message returned by TeamInviteCodeValidator" do
            expect(registration_settings_aggregator.call.success_message).to eq(team_invite_code_validator_response.success_message)
          end

          it "does not set an error message" do
            expect(registration_settings_aggregator.call.error_message).to be_blank
          end
        end

        context "when student registration is closed" do
          let(:student_registration_open) { false }

          context "when the team invite is valid" do
            let(:team_invite_code_valid) { true }

            it "opens registration for students" do
              expect(registration_settings_aggregator.call.student_registration_open?).to eq(true)
            end

            it "opens registration for parents" do
              expect(registration_settings_aggregator.call.parent_registration_open?).to eq(true)
            end
          end

          context "when the team invite is invalid" do
            let(:team_invite_code_valid) { false }

            it "does not open registration for students" do
              expect(registration_settings_aggregator.call.student_registration_open?).to eq(false)
            end

            it "does not open registration for parents" do
              expect(registration_settings_aggregator.call.parent_registration_open?).to eq(false)
            end

            context "when another registration type is open" do
              let(:judge_registration_open) { true }

              it "sets an error message indicating that the invite is invalid, but registration is still open" do
                expect(registration_settings_aggregator.call.error_message).to include("Sorry, this invitation is no longer valid, but you can still join Technovation")
              end
            end

            context "when all registration types are closed" do
              let(:student_registration_open) { false }
              let(:mentor_registration_open) { false }
              let(:judge_registration_open) { false }

              it "sets the error message to the message returned by TeamInviteCodeValidator" do
                expect(registration_settings_aggregator.call.error_message).to eq(team_invite_code_validator_response.error_message)
              end
            end
          end
        end
      end
    end

    context "when the invite is for a mentor" do
      let(:registration_profile_type) { "mentor" }

      context "when mentor registration is open" do
        let(:mentor_registration_open) { true }

        context "when the team invite is valid" do
          let(:team_invite_code_valid) { true }

          it "opens registration for mentors" do
            expect(registration_settings_aggregator.call.mentor_registration_open?).to eq(true)
          end

          it "sets the success message to the message returned by TeamInviteCodeValidator" do
            expect(registration_settings_aggregator.call.success_message).to eq(team_invite_code_validator_response.success_message)
          end

          it "does not set an error message" do
            expect(registration_settings_aggregator.call.error_message).to be_blank
          end
        end

        context "when mentor registration is closed" do
          let(:mentor_registration_open) { false }

          context "when the team invite is invalid" do
            let(:team_invite_code_valid) { false }

            it "does not open registration for mentors" do
              expect(registration_settings_aggregator.call.mentor_registration_open?).to eq(false)
            end

            context "when another registration type is open" do
              let(:judge_registration_open) { true }

              it "sets an error message indicating that the invite is invalid, but registration is still open" do
                expect(registration_settings_aggregator.call.error_message).to include("Sorry, this invitation is no longer valid, but you can still join Technovation")
              end
            end

            context "when all registration types are closed" do
              let(:student_registration_open) { false }
              let(:mentor_registration_open) { false }
              let(:judge_registration_open) { false }

              it "sets the error message to the message returned by TeamInviteCodeValidator" do
                expect(registration_settings_aggregator.call.error_message).to eq(team_invite_code_validator_response.error_message)
              end
            end
          end
        end
      end
    end
  end
end
