require "rails_helper"

RSpec.describe LocationController do
  %w{mentor student}.each do |scope|
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

  describe "GET /registration/current_location with NullSignupAttempt" do
    it "returns the IP geolocation result anyway" do
      result = double(:GeocoderResult,
        coordinates: [1.23, 4.56],
        latitude: 1.23,
        longitude: 4.56,
        city: "Chicago",
        state_code: "IL",
        state: "Illinois",
        country_code: "US",
        country: "United States",
      )

      expect(Geocoder).to receive(:search) { [result] }

      get "/registration/current_location"

      json = JSON.parse(response.body)
      expect(json["city"]).to eq("Chicago")
      expect(json["state"]).to eq("Illinois")
      expect(json["country"]).to eq("United States")
      expect(json["country_code"]).to eq("US")
    end
  end
end