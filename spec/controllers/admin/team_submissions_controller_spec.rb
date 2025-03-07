require "rails_helper"

RSpec.describe Admin::TeamSubmissionsController do
  describe "GET #index :json" do
    it "exports csv okay" do
      sign_in(:admin)

      expect {
        get :index, format: :json, params: {submissions_grid: {}}
      }.to change { Export.count }.by(1)
    end
  end

  describe "PATCH #return_to_judging_pool" do
    let(:team_submission) { FactoryBot.create(:submission, removed_from_judging_pool: true) }
    let(:admin) { FactoryBot.create(:admin) }

    it "sets removed from judging pool to false" do
      sign_in(admin)

      patch :return_to_judging_pool, params: {team_submission_id: team_submission.id}

      team_submission.reload
      expect(team_submission.removed_from_judging_pool).to be false
      expect(team_submission.returned_to_judging_pool_by_account_id).to eq(admin.account.id)
    end
  end
end
