# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PasswordsController do
  describe "GET #new" do
    it "renders for an admin with an expired password" do
      admin = FactoryBot.create(:admin)
      admin.account.update_columns(password_changed_at: 91.days.ago)
      sign_in(admin)

      get :new

      expect(response).to render_template(:new)
    end
  end

  describe "PATCH #update" do
    it "updates an expired password and restores admin access" do
      admin = FactoryBot.create(:admin)
      admin.account.update_columns(password_changed_at: 91.days.ago)
      sign_in(admin)

      Timecop.freeze do
        expect {
          patch :update, params: {
            account: {password: PasswordHelpers::VALID_ADMIN_PASSWORD}
          }
        }.to change { SecurityEvent.where(event_type: "password.changed").count }.by(1)

        expect(response).to redirect_to(admin_dashboard_path)
        expect(admin.account.reload.password_changed_at).to be_within(1.second).of(Time.current)
        expect(admin.account.password_expired?).to be(false)
      end
    end

    it "rejects a password that does not meet admin complexity rules" do
      admin = FactoryBot.create(:admin)
      admin.account.update_columns(password_changed_at: 91.days.ago)
      digest = admin.account.password_digest
      sign_in(admin)

      patch :update, params: {account: {password: "tooshort"}}

      expect(response).to render_template(:new)
      expect(admin.account.reload.password_digest).to eq(digest)
    end
  end
end
