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
end