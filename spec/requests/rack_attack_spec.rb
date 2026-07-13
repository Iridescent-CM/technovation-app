# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Rack::Attack", type: :request do
  around do |example|
    Rack::Attack.cache.store.clear
    Rack::Attack.enabled = true
    Timecop.freeze { example.run }
  ensure
    Rack::Attack.enabled = false
    Rack::Attack.cache.store.clear
  end

  def post_signin(ip: "203.0.113.1")
    post "/signins",
      params: {account: {email: "nobody@example.com", password: "wrong"}},
      env: {"REMOTE_ADDR" => ip}
  end

  def post_password_reset(ip: "203.0.113.2")
    post "/password_resets",
      params: {password_reset: {email: "nobody@example.com"}},
      env: {"REMOTE_ADDR" => ip}
  end

  describe "POST /signins IP throttling" do
    it "allows requests under the limit" do
      Rack::Attack::SIGNINS_LIMIT.times { post_signin }

      expect(response).not_to have_http_status(:too_many_requests)
    end

    it "returns 429 when the limit is exceeded" do
      (Rack::Attack::SIGNINS_LIMIT + 1).times { post_signin }

      expect(response).to have_http_status(:too_many_requests)
      expect(response.body).to include(I18n.t("controllers.rack_attack.throttled"))
    end
  end

  describe "POST /password_resets IP throttling" do
    it "allows requests under the limit" do
      Rack::Attack::PASSWORD_RESETS_LIMIT.times { post_password_reset }

      expect(response).not_to have_http_status(:too_many_requests)
    end

    it "returns 429 when the limit is exceeded" do
      (Rack::Attack::PASSWORD_RESETS_LIMIT + 1).times { post_password_reset }

      expect(response).to have_http_status(:too_many_requests)
      expect(response.body).to include(I18n.t("controllers.rack_attack.throttled"))
    end
  end
end
