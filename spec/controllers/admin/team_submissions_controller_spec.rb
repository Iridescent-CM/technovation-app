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
end
