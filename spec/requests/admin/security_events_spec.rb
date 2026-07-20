# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin security events", type: :request do
  describe "GET /admin/security_events" do
    it "lists security events for an admin" do
      account = FactoryBot.create(:account)
      SecurityEventLogger.log(
        event_type: "login.success",
        account: account,
        actor: account,
        metadata: {source: "request-spec"}
      )

      sign_in(:admin)
      get admin_security_events_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("login.success")
      expect(response.body).to include(account.email)
    end

    it "filters by event type" do
      account = FactoryBot.create(:account)
      SecurityEventLogger.log(
        event_type: "login.success",
        account: account,
        metadata: {marker: "success-marker"}
      )
      SecurityEventLogger.log(
        event_type: "logout",
        account: account,
        metadata: {marker: "logout-marker"}
      )

      sign_in(:admin)
      get admin_security_events_path, params: {
        security_events_grid: {event_type: "logout"}
      }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("logout-marker")
      expect(response.body).not_to include("success-marker")
      expect(response.body).to include("1")
      expect(response.body).to include("security events")
    end

    it "denies non-admin access" do
      student = FactoryBot.create(:student)
      sign_in(student)

      get admin_security_events_path

      expect(response).not_to have_http_status(:ok)
      expect(response.body).not_to include("Security Events")
    end
  end
end
