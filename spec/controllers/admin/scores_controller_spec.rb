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
  end
end