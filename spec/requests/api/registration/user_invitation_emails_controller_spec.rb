require "rails_helper"

RSpec.describe "User Invitation Emails API", type: :request do
  describe "GET /api/registration/user_invitation_email" do
    let(:registration_invite) {
      UserInvitation.create!(
        profile_type: :chapter_ambassador,
        email: "chapter_ambassador_invite@example.com",
        chapter_id: chapter.id
      )
    }
    let(:chapter) { FactoryBot.create(:chapter) }

    context "when the invite_code is valid" do
      before do
        get "/api/registration/user_invitation_email", params: {
          invite_code: registration_invite.admin_permission_token
        }
      end

      it "returns the email associated with the invitation" do
        json = JSON.parse(response.body)
        expect(json["email"]).to eq("chapter_ambassador_invite@example.com")
      end
    end
  end
end
