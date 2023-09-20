require "rails_helper"

RSpec.describe "Registration invites", :js do
  {
    student: "student",
    mentor: "mentor",
    judge: "judge",
    chapter_ambassador: "chapter ambassador"
  }.each do |profile_type, friendly_profile_type|
    let(:profile) {
      FactoryBot.create(
        profile_type,
        account: FactoryBot.create(:account, email: email_address)
      )
    }
    let(:email_address) { "#{profile_type}@example.com" }

    before do
      SeasonToggles.enable_signup(profile_type)
    end

    context "when a #{friendly_profile_type} is registering using an invite code" do
      let(:registration_invite) {
        UserInvitation.create!(
          profile_type: profile_type,
          email: email_address
        )
      }

      it "displays a message with the invited profile type" do
        visit signup_path(invite_code: registration_invite.admin_permission_token)

        expect(page).to have_content("You have been invited to join Technovation Girls as a #{friendly_profile_type}!")
      end

      it "pre-selects the invited profile type" do
        visit signup_path(invite_code: registration_invite.admin_permission_token)

        expect(page).to have_selector("input[type=radio]:checked##{profile_type}")
      end

      context "when a #{friendly_profile_type} invite code has alredy been used" do
        before do
          registration_invite.update(
            account: profile.account,
            status: :registered
          )
        end

        it "does not allow a #{friendly_profile_type} to use the invite code again" do
          visit signup_path(invite_code: registration_invite.admin_permission_token)

          expect(page).to have_content("This invitation is no longer valid")
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
