# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::ParticipantSessionsController do
  describe "GET #show" do
    it "records an impersonation start security event" do
      admin = FactoryBot.create(:admin)
      student = FactoryBot.create(:student)
      sign_in(admin)

      expect {
        get :show, params: {id: student.account_id}
      }.to change {
        SecurityEvent.where(
          event_type: "admin.impersonation.start",
          account_id: student.account_id,
          actor_account_id: admin.account_id
        ).count
      }.by(1)
    end
  end

  describe "DELETE #destroy" do
    it "records an impersonation stop security event" do
      admin = FactoryBot.create(:admin)
      student = FactoryBot.create(:student)
      sign_in(admin)
      get :show, params: {id: student.account_id}

      expect {
        delete :destroy, params: {id: student.account_id}
      }.to change {
        SecurityEvent.where(
          event_type: "admin.impersonation.stop",
          account_id: student.account_id,
          actor_account_id: admin.account_id
        ).count
      }.by(1)
    end
  end
end
