# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::AdminsController, "reactivate" do
  describe "PATCH #reactivate" do
    it "allows a super admin to reactivate a deactivated admin" do
      super_admin = FactoryBot.create(:admin, :super_admin)
      deactivated = FactoryBot.create(:admin)
      deactivated.account.update_columns(deactivated_at: 1.day.ago)
      sign_in(super_admin)

      expect {
        patch :reactivate, params: {admin_id: deactivated.account_id, id: deactivated.account_id}
      }.to change { SecurityEvent.where(event_type: "admin.reactivated").count }.by(1)

      expect(response).to redirect_to(admin_admins_path)
      expect(deactivated.account.reload.deactivated_at).to be_nil
    end

    it "forbids non-super admins from reactivating" do
      admin = FactoryBot.create(:admin)
      deactivated = FactoryBot.create(:admin)
      deactivated.account.update_columns(deactivated_at: 1.day.ago)
      sign_in(admin)

      patch :reactivate, params: {admin_id: deactivated.account_id, id: deactivated.account_id}

      expect(response).to redirect_to(root_path)
      expect(deactivated.account.reload.deactivated_at).to be_present
    end
  end
end
