require "rails_helper"

RSpec.describe Admin::Chapters::StatusController do
  before do
    sign_in(:admin)
  end
  describe "PATCH #activate" do
    context "When activating a chapter" do
      let(:chapter) { FactoryBot.create(:chapter) }

      it "adds the current season to the chapter's season list" do
        patch :activate, params: { chapter_id: chapter.id }
        expect(chapter.reload.seasons).to include(Season.current.year)
      end

      it "redirects to the chapter admin page" do
        patch :activate, params: { chapter_id: chapter.id }
        expect(response).to redirect_to(admin_chapter_path(chapter))
      end
    end
  end

  describe "PATCH #deactivate" do
    context "When deactivating a chapter" do
      let(:chapter) { FactoryBot.create(:chapter, :current) }

      it "removes the current season from the chapter's season list" do
        patch :deactivate, params: { chapter_id: chapter.id }
        expect(chapter.reload.seasons).not_to include(Season.current.year)
      end

      it "redirects to the chapter admin page" do
        patch :deactivate, params: { chapter_id: chapter.id }
        expect(response).to redirect_to(admin_chapter_path(chapter))
      end
    end
  end
end
