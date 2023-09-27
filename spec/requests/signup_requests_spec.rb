require "rails_helper"

RSpec.describe "Signing up", type: :request do
  describe "visiting the /signup page" do
    context "when registration is open" do
      before do
        SeasonToggles.registration_open!
      end

      it "renders the registration page" do
        get "/signup"

        expect(response).to render_template("new_registration/show")
      end

      context "when there is an invite code" do
        before do
          get "/signup?invite_code=xyz"
        end

        it "renders the registration page" do
          expect(response).to render_template("new_registration/show")
        end
      end
    end

    context "when registration is closed" do
      before do
        SeasonToggles.registration_closed!
      end

      it "redirects to the homepage" do
        get "/signup"

        expect(response).to redirect_to("/")
      end

      context "when there is an invalid invite code" do
        before do
          get "/signup?invite_code=lmnopqrst"
        end

        it "redirects to the homepage" do
          expect(response).to redirect_to("/")
        end
      end

      context "when there is a valid invite code that is not set to be used at any time" do
        let(:registration_invite) {
          UserInvitation.create!(
            profile_type: "mentor",
            email: "mentor.mcgee.invite@example.com",
            register_at_any_time: false
          )
        }

        it "redirects to the homepage" do
          get "/signup?invite_code=#{registration_invite.admin_permission_token}"

          expect(response).to redirect_to("/")
        end
      end

      context "when there is a valid invite code that is set to be used at any time" do
        let(:registration_invite) {
          UserInvitation.create!(
            profile_type: "judge",
            email: "judge.judy.invite@example.com",
            register_at_any_time: true
          )
        }

        it "renders the registration page" do
          get "/signup?invite_code=#{registration_invite.admin_permission_token}"

          expect(response).to render_template("new_registration/show")
        end
      end
    end
  end
end
