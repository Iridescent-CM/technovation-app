require "rails_helper"

RSpec.describe Application::DashboardsController do
  context "when visitors have a location cookie" do
    it "does not add a cookie" do
      expect {
        get :show
      }.not_to change {
        @response.cookies[CookieNames::IP_GEOLOCATION]
      }
    end
  end

  context "when visitors do not have a location cookie"
end