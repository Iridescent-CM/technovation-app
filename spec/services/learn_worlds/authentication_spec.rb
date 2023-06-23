require "rails_helper"

RSpec.describe LearnWorlds::Authentication do
  let(:learn_worlds_authentication) {
    LearnWorlds::Authentication.new(
      client_id: client_id,
      client_secret: client_secret,
      base_url: base_url,
      http_client: http_client,
      logger: logger,
      error_notifier: error_notifier
    )
  }

  let(:client_id) { "abcd_client_id" }
  let(:client_secret) { "1234_client_secret" }
  let(:base_url) { "https://learn-worlds-base-url" }
  let(:http_client) { class_double(Faraday).as_stubbed_const }
  let(:logger) { instance_double(Logger) }
  let(:error_notifier) { class_double(Airbrake).as_stubbed_const }

  before do
    allow(http_client).to receive(:new).with(
      url: base_url,
      headers: {
        "Lw-Client" => client_id
      }
    )
    allow(http_client).to receive_message_chain(:new, :post).and_return(mock_learn_worlds_response)
  end

  let(:mock_learn_worlds_response) do
    double("mock_learn_worlds_response",
      body: {
        success: true,
        tokenData: { access_token: "new_access_token_from_learn_worlds" }
      }.to_json
    )
  end

  describe "#access_token" do
    context "when the access token is cached" do
      before do
        allow(Rails).to receive_message_chain(:cache, :fetch).and_return("cached_token")
      end

      it "returns the cached access token" do
        learn_worlds_authentication.access_token

        expect(learn_worlds_authentication.access_token).to eq("cached_token")
      end

      it "does not call #get_access_token" do
        learn_worlds_authentication.access_token

        expect(learn_worlds_authentication).not_to receive(:get_access_token)
      end
    end

    context "when forcing a cache refresh" do
      it "returns a new access token" do
        learn_worlds_authentication.access_token(force_cache_refresh: true)

        expect(learn_worlds_authentication.access_token).to eq("new_access_token_from_learn_worlds")
      end
    end
  end

  describe "#refresh_access_token" do
    it "returns a new access token" do
      learn_worlds_authentication.refresh_access_token

      expect(learn_worlds_authentication.access_token).to eq("new_access_token_from_learn_worlds")
    end
  end
end
