require "rails_helper"

RSpec.describe LocationController do
  %w[mentor student].each do |scope|
    context "POST /#{scope}/location" do
      it "saves and geocodes to the current account" do
        profile = FactoryBot.create(scope, :chicago)
        sign_in(profile)

        post "/#{scope}/location", params: {
          "#{scope}_location": {
            city: "Los Angeles",
            state: "California",
            country: "US"
          }
        }

        expect(profile.reload.city).to eq("Los Angeles")
        expect(profile.state_province).to eq("CA")
        expect(profile.latitude).to eq(34.052363)
      end
    end
  end

  %w[mentor student judge admin].each do |scope|
    context "PATCH #{scope}/locations" do
      before do
        @account = FactoryBot.create(scope).account
        sign_in(@account)
      end

      it "returns 404 for invalid search data" do
        patch "/#{scope}/location", params: {
          "#{scope}_location" => {city: "x"},
          :account_id => @account.id
        }

        expect(response.status).to eq(404)
      end

      it "returns OK for valid single-result search data" do
        patch "/#{scope}/location", params: {
          "#{scope}_location" => {city: "Chicago"},
          :account_id => @account.id
        }

        expect(response.status).to eq(200)

        json = JSON.parse(response.body)["results"]
        expect(json.count).to eq(1)
        expect(json[0]["city"]).to eq("Chicago")
        expect(json[0]["state"]).to eq("Illinois")
        expect(json[0]["country"]).to eq("United States")
        expect(json[0]["country_code"]).to eq("US")
      end

      it "returns 300 for valid multi-result search data" do
        patch "/#{scope}/location", params: {
          "#{scope}_location" => {city: "stub-multiple"},
          :account_id => @account.id
        }

        expect(response.status).to eq(300)

        json = JSON.parse(response.body)["results"]
        expect(json).to be_many
      end
    end
  end
end
