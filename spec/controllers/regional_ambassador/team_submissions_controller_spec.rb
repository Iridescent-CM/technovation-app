require "rails_helper"

RSpec.describe RegionalAmbassador::TeamSubmissionsController do
  describe "GET #index" do
    it "forms grid params for out of US RAs" do
      sign_in(:ra, :brazil)
      get :index
      expect(response).to be_ok
    end
  end
end
