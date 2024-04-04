require "rails_helper"

RSpec.describe Docusign::Authentication do
  let(:docusign_authentication) {
    Docusign::Authentication.new(
      integration_id: integration_id,
      client_secret: client_secret,
      authorization_code: authorization_code,
      base_url: base_url,
      http_client: http_client,
      logger: logger,
      error_notifier: error_notifier
    )
  }

  let(:integration_id) { "abcd_client_id" }
  let(:client_secret) { "1234_client_secret" }
  let(:authorization_code) { "" }
  let(:base_url) { "https://docusign-base-url" }
  let(:http_client) { class_double(Faraday).as_stubbed_const }
  let(:logger) { instance_double(Logger) }
  let(:error_notifier) { class_double(Airbrake).as_stubbed_const }

  before do
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear

    allow(error_notifier).to receive(:notify)
    allow(logger).to receive(:error)
    allow(http_client).to receive(:new).with(
      url: base_url,
      headers: {
        "Authorization" => "Basic #{Base64.encode64(integration_id + ":" + client_secret).delete("\r\n")}"
      }
    ).and_return(http_client_instance)
  end

  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
  let(:http_client_instance) { double("http_client_instance") }

  before do
    allow(http_client_instance).to receive_message_chain(:post).and_return(mock_docusign_response)
  end

  let(:mock_docusign_response) do
    double("mock_docusign_response",
      body: {
        access_token: access_token,
        refresh_token: refresh_token
      }.to_json)
  end

  let(:access_token) { "Ix7v24C_ACCESS_TOKEN_l2sXnTmn" }
  let(:refresh_token) { "UxW8Bx_REFRESH_TOKEN_2FaPnbe" }
  let(:cached_access_token) { nil }

  describe "#access_token" do
    context "when an authorization code is present" do
      let(:authorization_code) { "eyJ0eXAiOi_AUTHORIZATION_CODE_WBV5tUMtz8" }

      it "uses the authorization code to get an access token" do
        expect(http_client_instance).to receive(:post).with(
          "oauth/token",
          {grant_type: "authorization_code", code: authorization_code}
        )

        docusign_authentication.access_token
      end

      it "returns an access token" do
        expect(docusign_authentication.access_token).to eq(access_token)
      end
    end

    context "when a refresh token is present" do
      before do
        allow(Rails).to receive_message_chain(:cache, :read).and_return(refresh_token)
      end

      let(:refresh_token) { "2nUS82a_REFRESH_TOKEN_p4x2Df0x" }

      it "uses the refresh token to get an access token" do
        expect(http_client_instance).to receive(:post).with(
          "oauth/token",
          {grant_type: "refresh_token", refresh_token: refresh_token}
        )

        docusign_authentication.access_token
      end

      it "returns an access token" do
        expect(docusign_authentication.access_token).to eq(access_token)
      end
    end

    context "when an authorization code and refresh token don't exist" do
      let(:authorization_code) { nil }
      let(:refresh_token) { nil }

      it "logs an error" do
        expect(logger).to receive(:error).with("[DOCUSIGN] An authorization code or refresh token is required to obtain an access token")

        docusign_authentication.access_token
      end

      it "notifities the error_notifier with the error" do
        expect(error_notifier).to receive(:notify).with("[DOCUSIGN] An authorization code or refresh token is required to obtain an access token")

        docusign_authentication.access_token
      end
    end

    context "when the access token is cached" do
      before do
        allow(Rails).to receive_message_chain(:cache, :fetch).and_return(access_token)
      end

      it "returns the cached access token" do
        docusign_authentication.access_token

        expect(docusign_authentication.access_token).to eq(access_token)
      end

      it "does not call #get_access_token_from_authorization_code to get an access token" do
        docusign_authentication.access_token

        expect(docusign_authentication).not_to receive(:get_access_token_from_authorization_code)
      end

      it "does not call #get_access_token_from_refresh_token to get an access token" do
        docusign_authentication.access_token

        expect(docusign_authentication).not_to receive(:get_access_token_from_refresh_token)
      end
    end

    context "when forcing a cache refresh" do
      context "when a refresh token is present" do
        before do
          allow(Rails).to receive_message_chain(:cache, :read).and_return(refresh_token)
        end

        let(:refresh_token) { "2nUS82a_REFRESH_TOKEN_p4x2Df0x" }

        it "returns a new access token from DocuSign" do
          docusign_authentication.access_token(force_cache_refresh: true)

          expect(docusign_authentication.access_token).to eq(access_token)
        end
      end

      context "when a refresh token don't exist" do
        let(:refresh_token) { nil }

        it "logs an error" do
          expect(logger).to receive(:error).with("[DOCUSIGN] An authorization code or refresh token is required to obtain an access token")

          docusign_authentication.access_token
        end

        it "notifities the error_notifier with the error" do
          expect(error_notifier).to receive(:notify).with("[DOCUSIGN] An authorization code or refresh token is required to obtain an access token")

          docusign_authentication.access_token
        end
      end
    end
  end

  describe "#refresh_access_token" do
    context "when a refresh token is present" do
      before do
        allow(Rails).to receive_message_chain(:cache, :read).and_return(refresh_token)
      end

      let(:refresh_token) { "2nUS82a_REFRESH_TOKEN_p4x2Df0x" }

      it "returns a new access token from DocuSign" do
        docusign_authentication.refresh_access_token

        expect(docusign_authentication.access_token).to eq(access_token)
      end
    end

    context "when a refresh token don't exist" do
      let(:refresh_token) { nil }

      it "logs an error" do
        expect(logger).to receive(:error).with("[DOCUSIGN] An authorization code or refresh token is required to obtain an access token")

        docusign_authentication.access_token
      end

      it "notifities the error_notifier with the error" do
        expect(error_notifier).to receive(:notify).with("[DOCUSIGN] An authorization code or refresh token is required to obtain an access token")

        docusign_authentication.access_token
      end
    end
  end
end
