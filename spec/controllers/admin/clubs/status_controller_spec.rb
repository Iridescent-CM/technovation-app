require "rails_helper"

RSpec.describe Admin::Clubs::StatusController do
  before do
    sign_in(:admin)
  end
  describe "PATCH #activate" do
    context "When activating a club" do
      let(:club) { FactoryBot.create(:club) }

      it "adds the current season to the club's season list" do
        patch :activate, params: { club_id: club.id }
        expect(club.reload.seasons).to include(Season.current.year)
      end

      it "redirects to the club admin page" do
        patch :activate, params: { club_id: club.id }
        expect(response).to redirect_to(admin_club_path(club))
      end
    end
  end

  describe "PATCH #deactivate" do
    context "When deactivating a club" do
      let(:club) { FactoryBot.create(:club, :current) }

      it "removes the current season from the club's season list" do
        patch :deactivate, params: { club_id: club.id }
        expect(club.reload.seasons).not_to include(Season.current.year)
      end

      it "redirects to the club admin page" do
        patch :deactivate, params: { club_id: club.id }
        expect(response).to redirect_to(admin_club_path(club))
      end
    end
  end
end
