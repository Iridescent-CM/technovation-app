require "rails_helper"

%w{student mentor judge regional_ambassador}.each do |scope|
  RSpec.describe "#{scope.camelize}::ProfilesController".safe_constantize do
    let(:profile) { FactoryGirl.create(scope, :geocoded, email: "old@oldtime.com") }

    before do
      sign_in(profile)
      allow(UpdateProfileOnEmailListJob).to receive(:perform_later)
    end

    it "updates newsletters with a change to the address" do
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
        .with(profile.account_id, profile.account.email, "#{scope.upcase}_LIST_ID")
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
