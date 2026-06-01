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
  end
end
