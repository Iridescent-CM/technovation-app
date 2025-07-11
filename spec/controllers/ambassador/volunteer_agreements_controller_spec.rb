require "rails_helper"

RSpec.describe Ambassador::VolunteerAgreementsController do
  let(:club_ambassador) { FactoryBot.create(:club_ambassador) }
  before do
    club_ambassador.volunteer_agreement.delete
    sign_in(club_ambassador)
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a valid volunteer agreement for the Club Ambassador" do
        expect {
          post :create, params: {
            volunteer_agreement: { electronic_signature: "Hello World" }
          }
        }.to change { VolunteerAgreement.count }.by(1)
      end

      it "redirects to the volunteer agreement show page" do
        post :create, params: {
          volunteer_agreement: { electronic_signature: "Hello World" }
        }

        expect(response).to redirect_to(club_ambassador_volunteer_agreement_path)
      end
    end

    context "without an electronic signature" do
      it "does not create a valid volunteer agreement for the Club Ambassador" do
        expect {
          post :create, params: {
            volunteer_agreement: { electronic_signature: nil }
          }
        }.not_to change { VolunteerAgreement.count }
      end

      it "renders the new template" do
        post :create, params: {
          volunteer_agreement: { electronic_signature: nil }
        }

        expect(response).to render_template(:new)
      end
    end
  end
end
