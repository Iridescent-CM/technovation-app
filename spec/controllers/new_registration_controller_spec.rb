require "rails_helper"

RSpec.describe NewRegistrationController do
  describe "POST #create" do
    context "when registering as a chapter ambassador" do
      let(:registration_invite) {
        UserInvitation.create!(
          profile_type: :chapter_ambassador,
          email: "chapter_ambassador_invite@example.com",
          chapter_id: chapter.id
        )
      }
      let(:chapter) { FactoryBot.create(:chapter) }

      before do
        post :create, params: {
          profileType: "chapter_ambassador", 
          inviteCode: registration_invite.admin_permission_token,
          new_registration: {
            email: "sjones@example.com", 
            firstName: "Sylvia", 
            lastName: "Jones", 
            gender: "Female", 
            dateOfBirth: "2001-01-21", 
            chapterAmbassadorOrganizationCompanyName: "Museum of Natural History", 
            chapterAmbassadorJobTitle: "Curator", 
            chapterAmbassadorBio: "We live inside a treehouse at the center of the museum, we have been protecting the museum's secrets for generations. We making sure that everyone is safe and happy – without the outside world learning about the museum's secrets.",
            dataTermsAgreedTo: true, 
            password: "123abc*&^"
          }
        }
      end

      it "assigns the chapter from the invite to the newly created chapter ambassador" do
        expect(ChapterAmbassadorProfile.last.chapter_id).to eq(registration_invite.chapter_id)
      end

      it "updates the invitation to a registered status" do
        expect(registration_invite.reload.registered?).to eq(true)
      end
    end
  end
end