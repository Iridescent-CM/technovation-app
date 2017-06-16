require "rails_helper"

%w{student mentor judge regional_ambassador}.each do |scope|
  RSpec.describe "#{scope.camelize}::ProfilesController".safe_constantize do
    let(:profile) { FactoryGirl.create(scope, email: "old@oldtime.com") }

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
  end
end
