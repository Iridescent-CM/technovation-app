class Webhooks::DocusignController < Webhooks::BaseController
  def create
    ProcessDocusignWebhookPayloadJob.perform_later(webhook_payload_id: @webhook_payload.id)

    head :ok
  end
end
