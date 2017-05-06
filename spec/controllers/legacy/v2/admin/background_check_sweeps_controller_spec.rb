require 'rails_helper'

RSpec.describe Legacy::V2::Admin::BackgroundCheckSweepsController, type: :controller do
  describe 'POST #create' do
    before do
      admin = FactoryGirl.create(:legacy_admin)
      legacy_sign_in(admin)
    end

    it 'sets the job to perform later on pending, consider, suspended items' do
      allow(Legacy::V2::SweepBackgroundChecksJob).to receive(:perform_later)

      post :create

      expect(Legacy::V2::SweepBackgroundChecksJob).to have_received(:perform_later)
        .with('pending', 'consider', 'suspended')
    end

    it 'redirects back to http_referer' do
      request.env["HTTP_REFERER"] = "/admin/dashboard"

      post :create

      expect(response).to redirect_to("/admin/dashboard")
    end

    it 'redirects to a fallback for no referer' do
      request.env["HTTP_REFERER"] = nil

      post :create

      expect(response).to redirect_to(legacy_v2_admin_background_checks_path)
    end
  end
end
