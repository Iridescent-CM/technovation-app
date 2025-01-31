require "rails_helper"

RSpec.describe DataGrids::Ambassador::TeamSubmissionsController do
  describe "GET #index" do
    context "as a chapter ambassador" do
      before do
        sign_in(:chapter_ambassador)
      end

      it "returns an OK 200 status code" do
        get :index

        expect(response.status).to eq(200)
      end
    end

    context "as a club ambassador" do
      before do
        sign_in(:club_ambassador)
      end

      it "returns an OK 200 status code" do
        get :index

        expect(response.status).to eq(200)
      end
    end
  end
end
