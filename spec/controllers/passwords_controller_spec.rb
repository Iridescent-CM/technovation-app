# frozen_string_literal: true

require "rails_helper"

RSpec.describe PasswordsController do
  describe "POST #create" do
    it "records a password.reset security event" do
      account = FactoryBot.create(:account)
      account.enable_password_reset!

      expect {
        post :create, params: {
          password: {
            token: account.password_reset_token,
            password: "NewSecret123",
            password_confirmation: "NewSecret123"
          }
        }
      }.to change { SecurityEvent.where(event_type: "password.reset", account_id: account.id).count }.by(1)
    end
  end
end
