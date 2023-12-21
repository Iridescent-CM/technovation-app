require "rails_helper"

RSpec.describe Admin::SignupsController do
  describe "GET #new" do
    it "requires a valid token" do
      admin = FactoryBot.create(:admin, :inviting)
      student = FactoryBot.create(:student)

      ["", nil, " ", "doesnt-match", student.admin_invitation_token].each do |bad_token|
        get :new, params: {token: bad_token}
        expect(response).to redirect_to(root_path)
      end

      get :new, params: {token: admin.admin_invitation_token}
      expect(response).to render_template("admin/signups/new")
    end
  end

  describe "PATCH #update" do
    it "requires a valid admin" do
      admin = FactoryBot.create(:admin, :inviting)
      student = FactoryBot.create(:student)

      sign_in(student)

      patch :update, params: {account: {password: SecureRandom.hex(10)}}
      expect(response).to redirect_to(root_path)
    end

    it "requires a valid password" do
      admin = FactoryBot.create(:admin, :inviting)
      password_digest = admin.password_digest

      sign_in(admin)

      patch :update, params: {account: {password: SecureRandom.hex(9)}}
      expect(response).to render_template("admin/signups/new")
      expect(admin.reload.password_digest).to eq(password_digest)

      patch :update, params: {account: {password: SecureRandom.hex(10)}}
      expect(response).to redirect_to(admin_dashboard_path)
      expect(admin.reload.password_digest).not_to eq(password_digest)
    end

    it "sets admins to a full status with the valid password update" do
      admin = FactoryBot.create(:admin, :inviting)

      sign_in(admin)

      patch :update, params: {account: {password: SecureRandom.hex(9)}}
      expect(admin.reload.account).not_to be_full_admin

      patch :update, params: {account: {password: SecureRandom.hex(10)}}
      expect(response).to redirect_to(admin_dashboard_path)
      expect(admin.reload.account).to be_full_admin
    end

    it "regenerates their invitation token with the valid password update" do
      admin = FactoryBot.create(:admin, :inviting)
      invite_token = admin.admin_invitation_token

      sign_in(admin)

      patch :update, params: {account: {password: SecureRandom.hex(9)}}
      expect(admin.reload.admin_invitation_token).to eq(invite_token)

      patch :update, params: {account: {password: SecureRandom.hex(10)}}
      expect(response).to redirect_to(admin_dashboard_path)
      expect(admin.reload.admin_invitation_token).not_to eq(invite_token)
    end
  end
end
