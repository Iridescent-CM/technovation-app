require "rails_helper"

RSpec.describe ChapterAmbassador::TeamSubmissionsController do
  describe "GET #index" do
    it "forms grid params for out of US chapter ambassadors" do
      sign_in(:chapter_ambassador, :brazil)
      get :index
      expect(response).to be_ok
    end
  end
end
