class ProcessDocusignWebhookPayloadJob < ActiveJob::Base
  queue_as :default

  def perform(
    webhook_payload_id:,
    logger: Rails.logger,
    error_notifier: Airbrake
  )

    webhook_payload = WebhookPayload.find(webhook_payload_id)
    parsed_payload = JSON.parse(webhook_payload.body, symbolize_names: true)
    docusign_envelope_id = parsed_payload.dig(:data, :envelopeId)
    docusign_envelope_status = parsed_payload.dig(:data, :envelopeSummary, :status)
    docusign_envelope_completed_at = parsed_payload.dig(:data, :envelopeSummary, :completedDateTime)
    document = Document.find_by(docusign_envelope_id: docusign_envelope_id)

    if document.present? && docusign_envelope_status == "completed"
      document.update(
        signed_at: docusign_envelope_completed_at,
        season_signed: Season.current.year
      )

      webhook_payload.delete
    else
      error = "[DOCUSIGN WEBHOOK] Couldn't process payload with envelope id: #{docusign_envelope_id}"

      logger.error(error)
      error_notifier.notify(error)
    end
  end
end