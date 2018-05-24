require "rails_helper"

RSpec.describe "/regional_ambassador/judges", type: :request do
  describe "GET judges.json" do
    # Regression for airbrake error
    # Unsupported argument type: Symbol during export
    it "runs export job with grid / params" do
      ra = FactoryBot.create(:ra, :approved)
      judgey = FactoryBot.create(:judge, email: "judgey@judge.com")

      post '/signins', params: {
        account: {
          email: ra.email,
          password: "secret1234",
        },
      }

      url = "/regional_ambassador/judges.json"

      get url, params: {
        filename: "regression",
        judges_grid: {
          name_email: "judgey",
        },
        format: :json,
      }

      csv = File.read("./tmp/regression.csv")
      expect(csv).to include("judgey@judge.com")
    end
  end
end