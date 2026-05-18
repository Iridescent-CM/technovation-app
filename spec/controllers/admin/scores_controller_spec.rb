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

    it "limits quarterfinals index results to virtual submissions with fewer than 3 complete official scores" do
      included = FactoryBot.create(:team_submission, :complete)
      excluded = FactoryBot.create(:team_submission, :complete)

      FactoryBot.create(
        :submission_score,
        :complete,
        :virtual,
        :quarterfinals,
        team_submission: included
      )
      FactoryBot.create(
        :submission_score,
        :complete,
        :virtual,
        :quarterfinals,
        team_submission: excluded
      )

      included.update_column(:complete_quarterfinals_official_submission_scores_count, 2)
      excluded.update_column(:complete_quarterfinals_official_submission_scores_count, 3)

      admin = FactoryBot.create(:admin)
      sign_in(admin)

      get :index, params: {scored_submissions_grid: {round: "quarterfinals"}}

      submission_ids = assigns[:scored_submissions_grid].assets.map(&:id)
      expect(submission_ids).to include(included.id)
      expect(submission_ids).not_to include(excluded.id)
    end

    it "does not apply the complete score limit when viewing semifinals" do
      included = FactoryBot.create(:team_submission, :complete)

      FactoryBot.create(
        :submission_score,
        :complete,
        :virtual,
        :semifinals,
        team_submission: included
      )

      included.update_column(:complete_semifinals_official_submission_scores_count, 5)

      admin = FactoryBot.create(:admin)
      sign_in(admin)

      get :index, params: {scored_submissions_grid: {round: "semifinals"}}

      submission_ids = assigns[:scored_submissions_grid].assets.map(&:id)
      expect(submission_ids).to include(included.id)
    end
  end
end
