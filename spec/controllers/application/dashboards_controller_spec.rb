require "rails_helper"

RSpec.describe Application::DashboardsController do
  context "when visitors have a location cookie" do
    it "does not add a cookie" do
      controller.set_cookie(CookieNames::IP_GEOLOCATION, 'something')

      expect {
        get :show
      }.not_to change {
        response.cookies[CookieNames::IP_GEOLOCATION]
      }
    end
  end

  context "when visitors do not have a location cookie" do
    it "adds a cookie to the IP_GELOCATION key" do
      expect {
        get :show
      }.to change {
        @response.cookies[CookieNames::IP_GEOLOCATION]
      }
    end
  end
end