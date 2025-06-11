require "rails_helper"

RSpec.describe Admin::Ambassadors::SeasonStatusController do
  describe "PATCH #update" do

    before do
      sign_in(:admin)
    end

    context "When marking a chapter active" do
      let(:chapter) { FactoryBot.create(:chapter) }

      it "adds the current season to the chapter" do
        patch :update, params: {chapter_id: chapter.id, active: true}
        expect(chapter.reload.seasons).to include(Season.current.year)
      end

      it "redirects to the chapter admin page" do
        patch :update, params: {chapter_id: chapter.id, active: true}
        expect(response).to redirect_to(admin_chapter_path(chapter))
      end
    end

    context "When marking a chapter inactive" do
      let(:chapter) { FactoryBot.create(:chapter, :current) }

      it "removes the current season from the chapter" do
        patch :update, params: {chapter_id: chapter.id, active: false}
        expect(chapter.reload.seasons).not_to include(Season.current.year)
      end

      it "redirects to the chapter admin page" do
        patch :update, params: {chapter_id: chapter.id, active: false}
        expect(response).to redirect_to(admin_chapter_path(chapter))
      end
    end

    context "When marking a club active" do
      let(:club) { FactoryBot.create(:club) }

      it "adds the current season to the club" do
        patch :update, params: {club_id: club.id, active: true}
        expect(club.reload.seasons).to include(Season.current.year)
      end

      it "redirects to the club admin page" do
        patch :update, params: {club_id: club.id, active: true}
        expect(response).to redirect_to(admin_club_path(club))
      end
    end

    context "When marking a club inactive" do
      let(:club) { FactoryBot.create(:club, :current) }

      it "removes the current season from the club" do
        patch :update, params: {club_id: club.id, active: false}
        expect(club.reload.seasons).not_to include(Season.current.year)
      end

      it "redirects to the club admin page" do
        patch :update, params: {club_id: club.id, active: false}
        expect(response).to redirect_to(admin_club_path(club))
      end
    end
  end
end
