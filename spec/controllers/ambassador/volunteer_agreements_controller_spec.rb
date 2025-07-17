require "rails_helper"

RSpec.describe Ambassador::VolunteerAgreementsController do
  %w[chapter_ambassador club_ambassador].each do |ambassador|
    context "#{ambassador} " do
      let(:current_ambassador) { FactoryBot.create(ambassador) }
      before do
        current_ambassador.volunteer_agreement.delete
        sign_in(current_ambassador)
      end

      describe "POST #create" do
        context "with valid params" do
          it "creates a valid volunteer agreement for the #{ambassador}" do
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

            expect(response).to redirect_to(send("#{ambassador}_volunteer_agreement_path"))
          end
        end

        context "without an electronic signature" do
          it "does not create a valid volunteer agreement for the #{ambassador}" do
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
  end
end
