require "rails_helper"

RSpec.describe ChapterAmbassador::DashboardsController do
  describe "GET #show" do
    it "does not raise when the account timezone is a legacy IANA alias" do
      ambassador = FactoryBot.create(:chapter_ambassador)
      sign_in(ambassador)
      ambassador.account.update_column(:timezone, "Europe/Kiev")

      allow(Time).to receive(:find_zone).and_call_original
      allow(Time).to receive(:find_zone).with("Europe/Kiev").and_return(nil)

      expect { get :show }.not_to raise_error
      expect(response).to have_http_status(:ok)
    end

    it "falls back to the default zone when the timezone is unresolvable" do
      ambassador = FactoryBot.create(:chapter_ambassador)
      sign_in(ambassador)
      ambassador.account.update_column(:timezone, "Not/A/Timezone")

      allow(Time).to receive(:find_zone).and_return(nil)

      expect { get :show }.not_to raise_error
      expect(response).to have_http_status(:ok)
    end
  end
end
