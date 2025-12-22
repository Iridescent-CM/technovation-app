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

    allow(error_notifier).to receive(:notify)
  end

  context "sending documents" do
    before do
      allow(http_client_instance).to receive(:post).and_return(mock_docusign_response)
    end

    let(:mock_docusign_response) do
      double("mock_docusign_response",
        success?: docusign_response_successful,
        body: {
          enveloperId: "333-4444-55555-666666"
        }.to_json)
    end

    let(:docusign_response_successful) { true }

    describe "#send_chapter_affiliation_agreement" do
      let(:legal_contact) do
        instance_double(LegalContact,
          full_name: "Summer Skycedar",
          email_address: "summerhawk@example.com",
          job_title: "Counselor",
          chapter: chapter)
      end

      let(:chapter) do
        instance_double(Chapter,
          organization_name: "Thunder Mountain",
          location: "")
      end

      before do
        allow(legal_contact).to receive_message_chain(:documents, :create)
      end

      it "makes a call to the 'envelopes' endpoint and includes the api_account_id in the URL" do
        expect(http_client_instance).to receive(:post).with(
          "v2.1/accounts/#{api_account_id}/envelopes",
          anything
        )

        docusign_api_client.send_chapter_affiliation_agreement(
          legal_contact: legal_contact
        )
      end

      context "when the DocuSign response is successful" do
        let(:docusign_response_successful) { true }

        it "creates a new document for the legal contact" do
          expect(legal_contact).to receive_message_chain(:documents, :create)

          docusign_api_client.send_chapter_affiliation_agreement(
            legal_contact: legal_contact
          )
        end

        it "returns a successful result" do
          result = docusign_api_client.send_chapter_affiliation_agreement(
            legal_contact: legal_contact
          )

          expect(result.success?).to eq(true)
        end
      end

      context "when the DocuSign response is not successful" do
        let(:docusign_response_successful) { false }

        it "logs an error" do
          expect(logger).to receive(:error).with("[DOCUSIGN] Error sending document - ")

          docusign_api_client.send_chapter_affiliation_agreement(
            legal_contact: legal_contact
          )
        end

        it "sends an error to Airbrake" do
          expect(error_notifier).to receive(:notify).with("[DOCUSIGN] Error sending document - ")

          docusign_api_client.send_chapter_affiliation_agreement(
            legal_contact: legal_contact
          )
        end

        it "returns an unsuccessful result" do
          result = docusign_api_client.send_chapter_affiliation_agreement(
            legal_contact: legal_contact
          )

          expect(result.success?).to eq(false)
        end
      end
    end

    describe "#send_chapter_volunteer_agreement" do
      let(:chapter_ambassador_profile) do
        instance_double(ChapterAmbassadorProfile,
          full_name: "Kodi Skycedar",
          email_address: "kodibear@example.com",
          chapter: chapter)
      end

      let(:chapter) do
        instance_double(Chapter,
          organization_name: "Caterpillar Camp")
      end

      before do
        allow(chapter_ambassador_profile).to receive_message_chain(:documents, :create)
      end

      it "makes a call to the 'envelopes' endpoint and includes the api_account_id in the URL" do
        expect(http_client_instance).to receive(:post).with(
          "v2.1/accounts/#{api_account_id}/envelopes",
          anything
        )

        docusign_api_client.send_chapter_volunteer_agreement(
          chapter_ambassador_profile: chapter_ambassador_profile
        )
      end

      context "when the DocuSign response is successful" do
        let(:docusign_response_successful) { true }

        it "creates a new document for the legal contact" do
          expect(chapter_ambassador_profile).to receive_message_chain(:documents, :create)

          docusign_api_client.send_chapter_volunteer_agreement(
            chapter_ambassador_profile: chapter_ambassador_profile
          )
        end

        it "returns a successful result" do
          result = docusign_api_client.send_chapter_volunteer_agreement(
            chapter_ambassador_profile: chapter_ambassador_profile
          )

          expect(result.success?).to eq(true)
        end
      end

      context "when the DocuSign response is not successful" do
        let(:docusign_response_successful) { false }

        it "logs an error" do
          expect(logger).to receive(:error).with("[DOCUSIGN] Error sending document - ")

          docusign_api_client.send_chapter_volunteer_agreement(
            chapter_ambassador_profile: chapter_ambassador_profile
          )
        end

        it "sends an error to Airbrake" do
          expect(error_notifier).to receive(:notify).with("[DOCUSIGN] Error sending document - ")

          docusign_api_client.send_chapter_volunteer_agreement(
            chapter_ambassador_profile: chapter_ambassador_profile
          )
        end

        it "returns an unsuccessful result" do
          result = docusign_api_client.send_chapter_volunteer_agreement(
            chapter_ambassador_profile: chapter_ambassador_profile
          )

          expect(result.success?).to eq(false)
        end
      end
    end
  end

  describe "#void_document" do
    let(:document) do
      instance_double(Document,
        sent_at: document_sent_at,
        expired?: false,
        docusign_envelope_id: "tyuip-876-cvbn")
    end

    let(:document_sent_at) { Time.now }

    before do
      allow(http_client_instance).to receive(:put).and_return(mock_docusign_response)
      allow(document).to receive(:update)
    end

    let(:mock_docusign_response) do
      double("mock_docusign_response",
        success?: docusign_response_successful,
        body: {
          enveloperId: "333-4444-55555-666666"
        }.to_json)
    end

    let(:docusign_response_successful) { true }

    context "when the DocuSign response is successful" do
      let(:docusign_response_successful) { true }

      it "updates the document to be inactive and adds a 'voided at' timestamp" do
        Timecop.freeze(Time.now) do
          expect(document).to receive(:update).with(
            active: false,
            voided_at: Time.now
          )

          docusign_api_client.void_document(document)
        end
      end

      it "returns a successful result" do
        result = docusign_api_client.void_document(document)

        expect(result.success?).to eq(true)
      end
    end

    context "when the document is more than 120 days old" do
      let(:document_signed_at) { 121.days.ago }

      it "voids the document and marks it as inactive" do
        Timecop.freeze(Time.now) do
          expect(document).to receive(:update).with(
            status: "voided",
            voided_at: Time.now,
            active: false
          )

          docusign_api_client.void_document(document)
        end
      end

      it "returns a successful result" do
        result = docusign_api_client.void_document(document)

        expect(result.success?).to eq(true)
      end
    end

    context "when the DocuSign response is not successful" do
      let(:docusign_response_successful) { false }

      it "logs an error" do
        expect(logger).to receive(:error).with("[DOCUSIGN] Error voiding document - ")

        docusign_api_client.void_document(document)
      end

      it "sends an error to Airbrake" do
        expect(error_notifier).to receive(:notify).with("[DOCUSIGN] Error voiding document - ")

        docusign_api_client.void_document(document)
      end

      it "returns an unsuccessful result" do
        result = docusign_api_client.void_document(document)

        expect(result.success?).to eq(false)
      end
    end
  end
end
