require "rails_helper"

RSpec.describe Docusign::ApiClient do
  let(:docusign_api_client) do
    Docusign::ApiClient.new(
      api_account_id: api_account_id,
      base_url: base_url,
      authentication_service: authentication_service,
      http_client: http_client,
      logger: logger,
      error_notifier: error_notifier
    )
  end

  let(:api_account_id) { "abcd_account_id_lmnop" }
  let(:base_url) { "https://docusign-base-url" }
  let(:authentication_service) { instance_double(Docusign::Authentication, access_token: "test_token") }
  let(:http_client) { class_double(Faraday).as_stubbed_const }
  let(:http_client_instance) { double("Faraday instance") }
  let(:logger) { instance_double(ActiveSupport::Logger, error: true) }
  let(:error_notifier) { double("Airbrake") }

  before do
    allow(http_client).to receive(:new).with(
      url: base_url,
      headers: {
        "Authorization" => "Bearer #{authentication_service.access_token}",
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }
    ).and_return(http_client_instance)

    allow(http_client_instance).to receive(:post).and_return(mock_docusign_response)
    allow(error_notifier).to receive(:notify)
  end

  let(:mock_docusign_response) do
    double("mock_docusign_response",
      success?: docusign_response_successful,
      body: {
        enveloperId: "333-4444-55555-666666"
      }.to_json)
  end
  let(:docusign_response_successful) { true }

  describe "#send_memorandum_of_understanding" do
    let(:full_name) { "Summer Skycedar" }
    let(:email_address) { "summerhawk@example.com" }
    let(:organization_name) { "Thunder Mountain" }

    it "makes a call to the 'envelopes' endpoint and includes the api_account_id in the URL" do
      expect(http_client_instance).to receive(:post).with(
        "v2.1/accounts/#{api_account_id}/envelopes",
        anything
      )

      docusign_api_client.send_memorandum_of_understanding(
        full_name: full_name,
        email_address: email_address,
        organization_name: organization_name
      )
    end

    context "when the DocuSign response is successful" do
      let(:docusign_response_successful) { true }

      it "returns a successful result" do
        result = docusign_api_client.send_memorandum_of_understanding(
          full_name: full_name,
          email_address: email_address,
          organization_name: organization_name
        )

        expect(result.success?).to eq(true)
      end
    end

    context "when the DocuSign response is not successful" do
      let(:docusign_response_successful) { false }

      it "logs an error" do
        expect(logger).to receive(:error).with("[DOCUSIGN] Error sending MOU - ")

        docusign_api_client.send_memorandum_of_understanding(
          full_name: full_name,
          email_address: email_address,
          organization_name: organization_name
        )
      end

      it "sends an error to Airbrake" do
        expect(error_notifier).to receive(:notify).with("[DOCUSIGN] Error sending MOU - ")

        docusign_api_client.send_memorandum_of_understanding(
          full_name: full_name,
          email_address: email_address,
          organization_name: organization_name
        )
      end

      it "returns an unsuccessful result" do
        result = docusign_api_client.send_memorandum_of_understanding(
          full_name: full_name,
          email_address: email_address,
          organization_name: organization_name
        )

        expect(result.success?).to eq(false)
      end
    end
  end
end