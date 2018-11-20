require "rails_helper"

RSpec.describe "/regional_ambassador/judges", type: :request do
  describe "GET judges.json" do
    # Regression for airbrake error
    # Unsupported argument type: Symbol during export
    it "runs export job with grid / params" do
      ra = FactoryBot.create(:ra, :los_angeles, :approved)

      post '/signins', params: {
        account: {
          email: ra.email,
          password: "secret1234",
        },
      }

      FactoryBot.create(
        :judge,
        :los_angeles,
        account: FactoryBot.create(:account, email: "only-me@me.com")
      )

      FactoryBot.create(
        :judge,
        :los_angeles,
        account: FactoryBot.create(:account, email: "no_findy-email@judge.com")
      )

      FactoryBot.create(
        :judge,
        :chicago,
        account: FactoryBot.create(:account, email: "no_findy-region@judge.com")
      )

      url = "/regional_ambassador/judges.json"

      get url, params: {
        filename: "regression",
        judges_grid: {
          name_email: "only-me",
        },
        format: :json,
      }

      csv = File.read("./tmp/regression.csv")
      expect(csv).to include("only-me@me.com")

      expect(csv).not_to include("no_findy-email@judge.com")
      expect(csv).not_to include("no_findy-region@judge.com")
    end
  end

  describe "GET judges/index.html" do
    # Regression - first load of page without params, saved searches exist
    it "is okay on HTML with empty params" do
      ra = FactoryBot.create(:ra, :approved)
      ra.saved_searches.create!(
        param_root: "judges_grid",
        name: "testing 123",
        search_string: 'name_email="judgey"',
      )

      post '/signins', params: {
        account: {
          email: ra.email,
          password: "secret1234",
        },
      }

      get '/regional_ambassador/judges'
      expect(response).to be_ok
    end
  end
end