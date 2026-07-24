require "rails_helper"

RSpec.describe Admin::ScoresController do
  describe "GET #index" do
    it "provides a default grid_params[:round] of quarterfinals" do
      admin = FactoryBot.create(:admin)
      sign_in(admin)

      get :index, params: {scored_submissions_grid: {round: ""}}

      expect(assigns[:round]).to eq("quarterfinals")
    end

    it "provides a default grid_params[:round] of quarterfinals when judging is off" do
      SeasonToggles.judging_round_off!

      admin = FactoryBot.create(:admin)
      sign_in(admin)

      get :index

      expect(assigns[:round]).to eq("quarterfinals")
    end

    it "accepts a passed in round" do
      admin = FactoryBot.create(:admin)
      sign_in(admin)

      get :index, params: {scored_submissions_grid: {round: "semifinals"}}

      expect(assigns[:round]).to eq("semifinals")
    end

    it "applies nested scored_submissions_grid filters without global params.permit!" do
      admin = FactoryBot.create(:admin)
      sign_in(admin)

      get :index, params: {
        scored_submissions_grid: {
          round: "quarterfinals",
          country: ["US"],
          not_a_real_filter: "should-be-stripped"
        }
      }

      expect(response).to have_http_status(:ok)
      expect(assigns[:round]).to eq("quarterfinals")

      permitted = controller.send(:permitted_grid_params)
      expect(permitted[:country]).to eq(["US"])
      expect(permitted.keys.map(&:to_s)).not_to include("not_a_real_filter")
    end
  end
end
