require "rails_helper"

RSpec.describe "Using registration invite codes", :js do
  [
    {
      profile_type: "student",
      invite_profile_type: "student",
      registration_profile_type: "student",
      friendly_profile_type: "student"
    },
    {
      profile_type: "student",
      invite_profile_type: "parent_student",
      registration_profile_type: "parent",
      friendly_profile_type: "parent"
    },
    {
      profile_type: "mentor",
      invite_profile_type: "mentor",
      registration_profile_type: "mentor",
      friendly_profile_type: "mentor"
    },
    {
      profile_type: "judge",
      invite_profile_type: "judge",
      registration_profile_type: "judge",
      friendly_profile_type: "judge"
    },
    {
      profile_type: "chapter_ambassador",
      invite_profile_type: "chapter_ambassador",
      registration_profile_type: "chapter_ambassador",
      friendly_profile_type: "chapter ambassador"
    }
  ].each do |item|
    context "when a #{item[:friendly_profile_type]} is registering using an invite code" do
      let(:registration_invite) {
        UserInvitation.create!(
          profile_type: item[:invite_profile_type],
          email: email_address,
          register_at_any_time: register_at_any_time
        )
      }

      let(:profile) {
        FactoryBot.create(
          item[:profile_type],
          account: FactoryBot.create(:account, email: email_address)
        )
      }
      let(:email_address) { "#{item[:registration_profile_type]}@example.com" }
      let(:register_at_any_time) { false }

      context "when registration is open" do
        before do
          SeasonToggles.enable_signup(item[:profile_type])
        end

        it "displays a #{item[:friendly_profile_type]} invite message" do
          visit signup_path(invite_code: registration_invite.admin_permission_token)

          expect(page).to have_content("You have been invited to join Technovation Girls as a #{item[:friendly_profile_type]}!")
        end

        it "pre-selects the #{item[:friendly_profile_type]} profile type" do
          visit signup_path(invite_code: registration_invite.admin_permission_token)

          expect(page).to have_selector("input[type=radio]:checked##{item[:registration_profile_type]}")
        end

        context "when a #{item[:friendly_profile_type]} invite code has already been used" do
          before do
            registration_invite.update(
              account: profile.account,
              status: :registered
            )
          end

          it "does not allow a #{item[:friendly_profile_type]} to use the invite code again" do
            visit signup_path(invite_code: registration_invite.admin_permission_token)

            expect(page).to have_content("invitation is no longer valid")
          end
        end
      end

      context "when registration is closed" do
        before do
          SeasonToggles.disable_signups!
        end

        context "when the invitation can be used at any time" do
          let(:register_at_any_time) { true }

          it "displays a #{item[:friendly_profile_type]} invite message" do
            visit signup_path(invite_code: registration_invite.admin_permission_token)

            expect(page).to have_content("You have been invited to join Technovation Girls as a #{item[:friendly_profile_type]}!")
          end

          it "pre-selects the #{item[:friendly_profile_type]} profile type" do
            visit signup_path(invite_code: registration_invite.admin_permission_token)

            expect(page).to have_selector("input[type=radio]:checked##{item[:registration_profile_type]}")
          end
        end
      end
    end
  end

  describe "chapter ambassador invites" do
    let(:chapter_ambassado_registration_invite) {
      UserInvitation.create!(
        profile_type: :chapter_ambassador,
        email: "chapter_ambassador_invite@example.com"
      )
    }

    context "when visiting the registration page with a chapter ambassador invite code" do
      before do
        visit signup_path(invite_code: chapter_ambassado_registration_invite.admin_permission_token)
      end

      it "displays chapter ambassador registration information" do
        expect(page).to have_content("You have been invited to join Technovation Girls as a chapter ambassador!")
        expect(page).to have_selector("img.chapter_ambassador")
        expect(page).to have_selector("input[type=radio]#chapter_ambassador")
      end

      it "pre-selects the chapter ambassador profile type" do
        expect(page).to have_selector("input[type=radio]:checked#chapter_ambassador")
      end
    end

    context "when visiting the registration page WITHOUT a chapter ambassador invite code" do
      before do
        visit signup_path
      end

      it "does not display chapter ambassador registration information" do
        expect(page).not_to have_content("You have been invited to join Technovation Girls as a chapter ambassador!")
        expect(page).not_to have_selector("img.chapter_ambassador")
        expect(page).not_to have_selector("input[type=radio]#chapter_ambassador")
      end
    end

    context "when visiting the registration page with a chapter ambassador invite code that has been used already" do
      before do
        chapter_ambassado_registration_invite.update(status: :registered)

        visit signup_path(invite_code: chapter_ambassado_registration_invite.admin_permission_token)
      end

      it "does not display chapter ambassador registration information" do
        expect(page).not_to have_content("You have been invited to join Technovation Girls as a chapter ambassador!")
        expect(page).not_to have_selector("img.chapter_ambassador")
        expect(page).not_to have_selector("input[type=radio]#chapter_ambassador")
      end
    end
  end
end
