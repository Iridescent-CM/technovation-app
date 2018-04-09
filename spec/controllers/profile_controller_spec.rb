require "rails_helper"

%w{student mentor judge regional_ambassador}.each do |scope|
  klass = "#{scope.camelize}::ProfilesController".safe_constantize

  RSpec.describe klass do
    let(:profile) {
      FactoryBot.create(scope, :geocoded, email: "old@oldtime.com")
    }

    before do
      sign_in(profile)
      allow(UpdateProfileOnEmailListJob).to receive(:perform_later)
    end

    it "updates newsletters with a change to the #{scope} address" do
      patch :update, params: {
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            city: "Los Angeles",
            state_province: "CA",
          },
        },
      }

      expect(UpdateProfileOnEmailListJob).to have_received(:perform_later)
        .with(
          profile.account_id,
          profile.account.email,
          "#{scope.upcase}_LIST_ID"
        )
    end

    it "updates #{scope} newsletters with changes to first name" do
      patch :update, params: {
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            first_name: "someone cool",
          },
        },
      }

      expect(UpdateProfileOnEmailListJob).to have_received(:perform_later)
        .with(profile.account_id, profile.account.email, "#{scope.upcase}_LIST_ID")
    end

    it "updates #{scope} newsletters with changes to last name" do
      patch :update, params: {
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            last_name: "someone really cool",
          },
        },
      }

      expect(UpdateProfileOnEmailListJob).to have_received(:perform_later)
        .with(profile.account_id, profile.account.email, "#{scope.upcase}_LIST_ID")
    end

    it "errors out when #{scope} country is blank" do
      profile.account.update(
        city: nil,
        state_province: nil,
        country: nil,
        latitude: nil,
        longitude: nil,
      )

      patch :update, params: {
        setting_location: "1",

        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            city: "Los Angeles",
            state_province: "CA",
          },
        },
      }

      expect(profile.reload.latitude).to be_blank
      expect(profile.reload.longitude).to be_blank
      expect(response).to render_template("location_details/show")
    end

    it "geocodes when #{scope} address info changes" do
      # Sanity check
      expect(profile.latitude).to eq(41.50196838)
      expect(profile.longitude).to eq(-87.64051818)

      patch :update, params: {
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            city: "Los Angeles",
            state_province: "CA",
          },
        },
      }

      expect(profile.reload.latitude).to eq(34.052363)
      expect(profile.reload.longitude).to eq(-118.256551)
    end

    it "reverse geocodes when coords change" do
      ProfileUpdating.execute(
        profile,
        account_attributes: {
          id: profile.account_id,
          city: "Los Angeles",
          state_province: "CA",
          country: "US",
        }
      )

      # Sanity
      profile.reload
      expect(profile.city).to eq("Los Angeles")
      expect(profile.state_province).to eq("CA")
      expect(profile.latitude).to eq(34.052363)
      expect(profile.longitude).to eq(-118.256551)

      patch :update, params: {
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            latitude: 41.50196838,
            longitude: -87.64051818,
          },
        },
      }

      profile.reload
      expect(profile.city).to eq("Chicago")
      expect(profile.state_province).to eq("IL")
    end
  end
end
