class Webhooks::DocusignController < Webhooks::BaseController
  def create
    ProcessDocusignWebhookPayloadJob.perform_later(webhook_payload_id: @webhook_payload.id)

    head :ok
  end

  private

  def verify_webhook_payload
    if VerifyWebhookPayload
        .new(
          payload: request.body.read,
          secret: ENV.fetch("DOCUSIGN_HMAC_SECRET_KEY"),
          signature: request.headers["X-Docusign-Signature-1"]
        )
        .call
        .success?

      save_webhook_payload
    else
      head :ok
    end
  end
end
