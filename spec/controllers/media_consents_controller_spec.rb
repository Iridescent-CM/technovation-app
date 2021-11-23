require "rails_helper"

RSpec.describe MediaConsentsController do
  let(:student) { FactoryBot.create(:student) }
  let(:token) { student.account.consent_token }

  describe "GET #show" do
    before do
      FactoryBot.create(:media_consent, :signed, student_profile: student)

      get :show, params: {token: token}
    end

    context "when the consent token belonging to the student is provided" do
      let(:token) { student.account.consent_token }

      it "assigns @media_consent" do
        expect(assigns(:media_consent)).to eq(student.media_consent)
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end
    end

    context "when an invalid token is provided" do
      let(:token) { "radominvalidtoken" }

      it "redirects to the root url" do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "GET #edit" do
    context "when the consent token belonging to the student is provided" do
      let(:token) { student.account.consent_token }

      context "when the media consent form is unsigned" do
        before do
          FactoryBot.create(:media_consent, :unsigned, student_profile: student)
          FactoryBot.create(:parental_consent, :signed, student_profile: student)

          get :edit, params: {token: token}
        end

        it "assigns @media_consent" do
          expect(assigns(:media_consent)).to eq(student.media_consent)
        end

        it "assigns @parental_consent" do
          expect(assigns(:parental_consent)).to eq(student.parental_consent)
        end

        it "renders the edit template" do
          expect(response).to render_template(:edit)
        end
      end

      context "when the media consent form is already signed" do
        before do
          FactoryBot.create(:media_consent, :signed, student_profile: student)

          get :edit, params: {token: token}
        end

        it "redirects in order to view the media consent" do
          expect(response).to redirect_to(media_consent_url(params: {token: token}))
        end
      end
    end

    context "when an invalid token is provided" do
      let(:token) { "notavalidtoken" }

      it "redirects to the root url" do
        get :edit, params: {token: token}

        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PATCH #update" do
    before do
      FactoryBot.create(:media_consent, :unsigned, student_profile: student)
    end

    context "when the media consent is saved sucessfully (i.e. valid values are provided)" do
      before do
        patch :update, params: {
          id: student.media_consent.id,
          token: student.account.consent_token,
          media_consent: {
            electronic_signature: "Smarty Party Pants",
            consent_provided: "false"
          }
        }
      end

      it "redirects in order to view the media consent" do
        expect(response).to redirect_to(media_consent_url(params: {token: token}))
      end
    end

    context "when the media consent has errors (missing fields)" do
      before do
        patch :update, params: {
          id: student.media_consent.id,
          token: student.account.consent_token,
          media_consent: {
            electronic_signature: "",
            consent_provided: "true"
          }
        }
      end

      it "assigns @media_consent" do
        expect(assigns(:media_consent)).to eq(student.media_consent)
      end

      it "assigns @parental_consent" do
        expect(assigns(:parental_consent)).to eq(student.parental_consent)
      end

      it "renders the edit template again" do
        expect(response).to render_template(:edit)
      end
    end
  end
end
