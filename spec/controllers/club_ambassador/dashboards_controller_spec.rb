require "rails_helper"

RSpec.describe ClubAmbassador::DashboardsController do
  describe "GET #show" do
    it "does not raise when the account timezone is a legacy IANA alias" do
      ambassador = FactoryBot.create(:club_ambassador)
      sign_in(ambassador)
      ambassador.account.update_column(:timezone, "Asia/Calcutta")

      allow(Time).to receive(:find_zone).and_call_original
      allow(Time).to receive(:find_zone).with("Asia/Calcutta").and_return(nil)

      expect { get :show }.not_to raise_error
      expect(response).to have_http_status(:ok)
    end
  end
end
