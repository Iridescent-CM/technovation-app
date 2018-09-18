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
    end
  end

  describe "PATCH /registration/location with current_attempt" do
    include Rack::Test::Methods

    it "updates the attempt's lat/lng values" do
      attempt = FactoryBot.create(:signup_attempt, :chicago)

      set_cookie("#{CookieNames::SIGNUP_TOKEN}=#{attempt.wizard_token}")

      allow_any_instance_of(Registration::LocationsController).to(
        receive(:current_attempt).and_return(attempt)
      )

      patch "/registration/location", {
        registration_location: { city: "Los Angeles" }
      }

      expect(attempt.reload.city).to eq("Los Angeles")
      expect(attempt.state_code).to eq("CA")
      expect(attempt.latitude).to eq(34.052363)
    end
  end

  %w{mentor student judge admin registration}.each do |scope|
    context "PATCH #{scope}/locations" do
      before do
        if scope != 'registration'
          @account = FactoryBot.create(scope).account
          sign_in(@account)
        else
          @account = OpenStruct.new(id: '')
        end
      end

      it "returns 404 for invalid search data" do
        patch "/#{scope}/location", params: {
          "#{scope}_location" => { city: "x" },
          account_id: @account.id
        }

        expect(response.status).to eq(404)
      end

      it "returns OK for valid single-result search data" do
        patch "/#{scope}/location", params: {
          "#{scope}_location" => { city: "Chicago" },
          account_id: @account.id
        }

        expect(response.status).to eq(200)

        json = JSON.parse(response.body)["results"]
        expect(json.count).to eq(1)
        expect(json[0]["city"]).to eq("Chicago")
        expect(json[0]["state"]).to eq("Illinois")
        expect(json[0]["country"]).to eq("United States")
      end

      it "returns 300 for valid multi-result search data" do
        patch "/#{scope}/location", params: {
          "#{scope}_location" => { city: "stub-multiple" },
          account_id: @account.id
        }

        expect(response.status).to eq(300)

        json = JSON.parse(response.body)["results"]
        expect(json).to be_many
      end
    end
  end
end