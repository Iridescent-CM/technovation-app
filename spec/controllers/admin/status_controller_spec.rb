require "rails_helper"

RSpec.describe Admin::Chapterables::StatusController do
  before do
    sign_in(:admin)
  end
  describe "PATCH #active" do
    context "When marking a chapter active" do
      let(:chapter) { FactoryBot.create(:chapter) }

      it "adds the current season to the chapter" do
        patch :active, params: {chapter_id: chapter.id}
        expect(chapter.reload.seasons).to include(Season.current.year)
      end

      it "redirects to the chapter admin page" do
        patch :active, params: {chapter_id: chapter.id}
        expect(response).to redirect_to(admin_chapter_path(chapter))
      end
    end

    context "When marking a club active" do
      let(:club) { FactoryBot.create(:club) }

      it "adds the current season to the club" do
        patch :active, params: {club_id: club.id}
        expect(club.reload.seasons).to include(Season.current.year)
      end

      it "redirects to the club admin page" do
        patch :active, params: {club_id: club.id}
        expect(response).to redirect_to(admin_club_path(club))
      end
    end
  end

  describe "PATCH #inactive" do
    context "When marking a chapter inactive" do
      let(:chapter) { FactoryBot.create(:chapter, :current) }

      it "removes the current season from the chapter" do
        patch :inactive, params: {chapter_id: chapter.id}
        expect(chapter.reload.seasons).not_to include(Season.current.year)
      end

      it "redirects to the chapter admin page" do
        patch :inactive, params: {chapter_id: chapter.id}
        expect(response).to redirect_to(admin_chapter_path(chapter))
      end
    end

    context "When marking a club inactive" do
      let(:club) { FactoryBot.create(:club, :current) }

      it "removes the current season from the club" do
        patch :inactive, params: {club_id: club.id}
        expect(club.reload.seasons).not_to include(Season.current.year)
      end

      it "redirects to the club admin page" do
        patch :inactive, params: {club_id: club.id}
        expect(response).to redirect_to(admin_club_path(club))
      end
    end
  end
end
