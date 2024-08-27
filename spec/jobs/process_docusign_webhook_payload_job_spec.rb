require "rails_helper"

RSpec.describe ProcessDocusignWebhookPayloadJob do
  let(:webhook_payload) do
    double(
      WebhookPayload,
      id: 1,
      body: {
        data: {
          envelopeId: docusign_envelope_id,
          envelopeSummary: {
            status: docusign_envelope_status,
            completedDateTime: docusign_envelope_completed_at
          }
        }
      }.to_json(escape_html_entities: true)
    )
  end

  let(:docusign_envelope_id) { "xyz32a1b-c456-789d-ql2s-987654s3210t" }
  let(:docusign_envelope_status) { "completed" }
  let(:docusign_envelope_completed_at) { "2024-05-07T16:19:54.58Z" }
  let(:document) do
    double(Document,
      id: 2,
      docusign_envelope_id: docusign_envelope_id,
      signer_type: signer_type)
  end
  let(:signer_type) { "ChapterAmbassadorProfile" }
  let(:profile_type) { "student" }
  let(:logger) { instance_double(ActiveSupport::Logger, error: true) }
  let(:error_notifier) { double("Airbrake") }

  before do
    allow(WebhookPayload).to receive(:find).with(webhook_payload.id).and_return(webhook_payload)
    allow(Document).to receive(:find_by).with(docusign_envelope_id: docusign_envelope_id).and_return(document)
  end

  context "when a document exists and the DocuSign envelope has been been completed" do
    let(:document) do
      double(Document,
        id: 2,
        docusign_envelope_id: docusign_envelope_id,
        signer_type: signer_type)
    end
    let(:docusign_envelope_status) { "completed" }
    let(:signer_type) { "ChapterAmbassadorProfile" }

    before do
      allow(webhook_payload).to receive(:delete)
      allow(document).to receive(:update)
    end

    it "updates the document record" do
      expect(document).to receive(:update)
        .with(
          signed_at: docusign_envelope_completed_at,
          season_signed: Season.current.year,
          season_expires: nil
        )

      ProcessDocusignWebhookPayloadJob.perform_now(
        webhook_payload_id: webhook_payload.id
      )
    end

    context "when a legal contact is the person who signed the document" do
      let(:signer_type) { "LegalContact" }

      it "updates the document record and includes the season it will expire" do
        expect(document).to receive(:update)
          .with(
            signed_at: docusign_envelope_completed_at,
            season_signed: Season.current.year,
            season_expires: Season.current.year + LegalContact::NUMBER_OF_SEASONS_CHAPTER_AFFILIATION_AGREEMENT_IS_VALID_FOR - 1
          )

        ProcessDocusignWebhookPayloadJob.perform_now(
          webhook_payload_id: webhook_payload.id
        )
      end
    end

    it "deletes the webhook payload record" do
      expect(webhook_payload).to receive(:delete)

      ProcessDocusignWebhookPayloadJob.perform_now(
        webhook_payload_id: webhook_payload.id
      )
    end
  end

  context "when a document doesn't exist" do
    let(:document) { nil }

    before do
      allow(error_notifier).to receive(:notify)
    end

    it "logs a message" do
      expect(logger).to receive(:error).with(
        "[DOCUSIGN WEBHOOK] Couldn't process payload with envelope id: #{docusign_envelope_id}"
      )

      ProcessDocusignWebhookPayloadJob.perform_now(
        webhook_payload_id: webhook_payload.id,
        logger: logger,
        error_notifier: error_notifier
      )
    end

    it "sends an message to our error notifier (Airbrake)" do
      expect(error_notifier).to receive(:notify).with(
        "[DOCUSIGN WEBHOOK] Couldn't process payload with envelope id: #{docusign_envelope_id}"
      )

      ProcessDocusignWebhookPayloadJob.perform_now(
        webhook_payload_id: webhook_payload.id,
        logger: logger,
        error_notifier: error_notifier
      )
    end
  end

  context "when the DocuSign envelope status is not complete" do
    let(:docusign_envelope_status) { "" }

    before do
      allow(error_notifier).to receive(:notify)
    end

    it "logs an message" do
      expect(logger).to receive(:error).with(
        "[DOCUSIGN WEBHOOK] Couldn't process payload with envelope id: #{docusign_envelope_id}"
      )

      ProcessDocusignWebhookPayloadJob.perform_now(
        webhook_payload_id: webhook_payload.id,
        logger: logger,
        error_notifier: error_notifier
      )
    end

    it "sends an message to our error notifier (Airbrake)" do
      expect(error_notifier).to receive(:notify).with(
        "[DOCUSIGN WEBHOOK] Couldn't process payload with envelope id: #{docusign_envelope_id}"
      )

      ProcessDocusignWebhookPayloadJob.perform_now(
        webhook_payload_id: webhook_payload.id,
        logger: logger,
        error_notifier: error_notifier
      )
    end
  end
end
