require "rails_helper"

RSpec.describe ChapterAmbassador::ChapterAdminController do
  describe "GET #show" do
    let(:chapter_ambassador) { FactoryBot.create(:chapter_ambassador, :assigned_to_chapter) }

    before do
      allow_any_instance_of(ChapterAmbassadorProfile).to receive(:onboarded?)
        .and_return(chapter_ambassador_onboarded)
      allow_any_instance_of(Chapter).to receive(:onboarded?)
        .and_return(chapter_onboarded)

      sign_in(chapter_ambassador)
      get :show
    end

    let(:chapter_ambassador_onboarded) { false }
    let(:chapter_onboarded) { false }

    context "when the chapter and chapter ambassador are onboarded" do
      let(:chapter_onboarded) { true }
      let(:chapter_ambassador_onboarded) { true }

      it "renders the show template" do
        expect(response).to render_template(:show)
      end
    end

    context "when the chapter is onboarded and the chapter ambassador is not onboarded" do
      let(:chapter_onboarded) { true }
      let(:chapter_ambassador_onboarded) { false }

      it "redirects to the chapter ambassador dashboard" do
        expect(response).to redirect_to(chapter_ambassador_dashboard_path)
      end
    end

    context "when the chapter is not onboarded and the chapter ambassador is onboarded" do
      let(:chapter_onboarded) { false }
      let(:chapter_ambassador_onboarded) { true }

      it "redirects to the chapter ambassador dashboard" do
        expect(response).to redirect_to(chapter_ambassador_dashboard_path)
      end
    end

    context "when neither the chapter or chapter ambassador are onboarded" do
      let(:chapter_onboarded) { false }
      let(:chapter_ambassador_onboarded) { false }

      it "redirects to the chapter ambassador dashboard" do
        expect(response).to redirect_to(chapter_ambassador_dashboard_path)
      end
    end
  end
end
