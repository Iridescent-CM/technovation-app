require "rails_helper"

RSpec.describe LocationController do
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