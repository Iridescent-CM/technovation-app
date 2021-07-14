require "rails_helper"

RSpec.describe "/chapter_ambassador/judges", type: :request do
  describe "GET judges.json" do
    # Regression for airbrake error
    # Unsupported argument type: Symbol during export
    it "runs export job with grid / params" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :los_angeles, :approved)

      post '/signins', params: {
        account: {
          email: chapter_ambassador.email,
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

      url = "/chapter_ambassador/judges.json"

      perform_enqueued_jobs do
        get url, params: {
          filename: "regression",
          judges_grid: {
            name_email: "only-me",
          },
          format: :json,
        }
      end

      csv = File.read("./tmp/regression.csv")
      expect(csv).to include("only-me@me.com")

      expect(csv).not_to include("no_findy-email@judge.com")
      expect(csv).not_to include("no_findy-region@judge.com")
    end
  end

  describe "GET judges/index.html" do
    # Regression - first load of page without params, saved searches exist
    it "is okay on HTML with empty params" do
      chapter_ambassador = FactoryBot.create(:chapter_ambassador, :approved)
      chapter_ambassador.saved_searches.create!(
        param_root: "judges_grid",
        name: "testing 123",
        search_string: 'name_email="judgey"',
      )

      post '/signins', params: {
        account: {
          email: chapter_ambassador.email,
          password: "secret1234",
        },
      }

      get '/chapter_ambassador/judges'
      expect(response).to be_ok
    end
  end
end
