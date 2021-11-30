require "rails_helper"

%w{student mentor judge chapter_ambassador}.each do |scope|
  klass = "#{scope.camelize}::ProfilesController".safe_constantize

  RSpec.describe klass do
    let(:profile) {
      FactoryBot.create(scope, :geocoded, email: "old@oldtime.com")
    }

    before do
      sign_in(profile)
      allow(UpdateAccountOnEmailListJob).to receive(:perform_later)
    end

    it "updates newsletters with a change to the #{scope} address" do
      expect(UpdateAccountOnEmailListJob).to receive(:perform_later)
        .with(
          account_id: profile.account_id,
          currently_subscribed_as: profile.account.email
        )

      patch :update, params: {
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            city: "Salvador",
            state_province: "Bahia",
            country: "Brazil"
          }
        }
      }
    end

    it "updates #{scope} newsletters with changes to first name" do
      expect(UpdateAccountOnEmailListJob).to receive(:perform_later)
        .with(
          account_id: profile.account_id,
          currently_subscribed_as: profile.account.email
        )

      patch :update, params: {
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            first_name: "someone cool"
          }
        }
      }
    end

    it "updates #{scope} newsletters with changes to last name" do
      expect(UpdateAccountOnEmailListJob).to receive(:perform_later)
        .with(
          account_id: profile.account_id,
          currently_subscribed_as: profile.account.email
        )

      patch :update, params: {
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            last_name: "someone really cool"
          }
        }
      }
    end

    it "errors out when #{scope} country is blank" do
      profile.account.update(
        city: nil,
        state_province: nil,
        country: nil,
        latitude: nil,
        longitude: nil
      )

      patch :update, params: {
        :setting_location => "1",
        "#{scope}_profile" => {
          account_attributes: {
            id: profile.account_id,
            city: "Los Angeles",
            state_province: "CA"
          }
        }
      }

      expect(profile.reload.account).not_to be_valid_coordinates

      if scope != "student"
        expect(response).to redirect_to send(
          "#{scope}_location_details_path",
          return_to: send("#{scope}_dashboard_path")
        )
      end
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
            state_province: "CA"
          }
        }
      }

      expect(profile.reload.latitude).to eq(34.052363)
      expect(profile.reload.longitude).to eq(-118.256551)
    end
  end
end
