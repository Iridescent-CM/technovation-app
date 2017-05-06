require "rails_helper"

RSpec.describe Legacy::V2::Admin::BackgroundChecksController, type: :controller do
  describe '#GET index' do
    before do
      admin = FactoryGirl.create(:legacy_admin)
      legacy_sign_in(admin)

      FactoryGirl.create(:legacy_background_check, status: :pending)
      FactoryGirl.create(:legacy_background_check, status: :clear)
      FactoryGirl.create(:legacy_background_check, status: :consider)
      FactoryGirl.create(:legacy_background_check, status: :suspended)
    end

    BackgroundCheck.statuses.keys.each do |status|
      it "lists background checks by #{status} status" do
        get :index, params: { status: status }

        expect(response.body).to eq(BackgroundCheck.public_send(status).to_json)
      end
    end

    it "resets to page 1 if the result set is empty" do
      get :index, params: { page: 2 }

      expect(response.body).to eq(BackgroundCheck.pending.to_json)
    end
  end
end
