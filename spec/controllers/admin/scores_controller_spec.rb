require "rails_helper"

RSpec.describe Admin::ScoresController do
  describe "GET #index" do
    it "provides a default grid_params[:round] of quarterfinals" do
      qf_score = FactoryBot.create(:score, :quarterfinals)
      sf_score = FactoryBot.create(:score, :semifinals)

      admin = FactoryBot.create(:admin)
      sign_in(admin)

      get :index, params: { "scored_submissions_grid": { "round": "" } }

      expect(assigns[:scores]).to eq([qf_score])
    end

    it "provides a default grid_params[:round] of quarterfinals when judging is off" do
      SeasonToggles.judging_round_off!

      qf_score = FactoryBot.create(:score, :quarterfinals)
      sf_score = FactoryBot.create(:score, :semifinals)

      admin = FactoryBot.create(:admin)
      sign_in(admin)

      get :index

      expect(assigns[:scores]).to eq([qf_score])
    end

    it "accepts a passed in round" do
      qf_score = FactoryBot.create(:score, :quarterfinals)
      sf_score = FactoryBot.create(:score, :semifinals)

      admin = FactoryBot.create(:admin)
      sign_in(admin)

      get :index, params: { "scored_submissions_grid": { "round": "semifinals" } }

      expect(assigns[:scores]).to eq([sf_score])
    end
  end
end