require "rails_helper"

RSpec.describe Application::DashboardsController do
  context "when visitors have a location cookie" do
    it "does not add a cookie" do
      controller.set_cookie(CookieNames::IP_GEOLOCATION, '[31.123, -45.678]')

      expect {
        get :show
      }.not_to change {
        response.cookies[CookieNames::IP_GEOLOCATION]
      }
    end

    it "saves it to the logged in user" do
      student = FactoryBot.create(:student)

      result = double(:GeocoderResult,
        coordinates: [1.23, 4.56],
        city: 'Any',
        state_code: 'ANY',
        country_code: 'US',
      )

      expect(Geocoder).to receive(:search).twice { [result] }

      sign_in(student)
      get :show

      expect(controller.get_cookie(CookieNames::IP_GEOLOCATION)).to eq([1.23, 4.56])
      expect(student.account.reload.latitude).to eq(1.23)
      expect(student.account.longitude).to eq(4.56)
    end

    context "and the location is invalid" do
      it "tries again" do
        controller.set_cookie(CookieNames::IP_GEOLOCATION, "[0.0, 0.0]")

        result = double(:GeocoderResult, coordinates: [31.123, -45.678])
        expect(Geocoder).to receive(:search).with("0.0.0.0").and_return([result])

        expect {
          get :show
        }.to change {
          controller.get_cookie(CookieNames::IP_GEOLOCATION)
        }.to([31.123, -45.678])
      end
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

    it "stores the lat, lng coordinates for IP address value"  do
      request.remote_ip = "192.168.1.1"

      result = double(:GeocoderResult, coordinates: [31.1324413, -45.1038208])

      expect(Geocoder).to receive(:search)
        .with("192.168.1.1")
        .and_return([result])

      get :show

      results = controller.get_cookie(CookieNames::IP_GEOLOCATION)
      expect(results).to eq([31.1324413, -45.1038208])
    end
  end
end