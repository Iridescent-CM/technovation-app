class Webhooks::TwilioController < Webhooks::BaseController
  def create
    ProcessTwilioWebhookPayloadJob.perform_later(webhook_payload_id: @webhook_payload.id)
    head :ok
  end

  private

  def verify_webhook_payload
    api_auth_token = ENV.fetch("TWILIO_AUTH_TOKEN")
    validator = Twilio::Security::RequestValidator.new(api_auth_token)
    technovation_twilio_webhook_url = ENV.fetch("TECHNOVATION_TWILIO_WEBHOOK_URL")
    params = request.request_parameters
    twilio_signature = request.headers["X-Twilio-Signature"]

    if validator.validate(technovation_twilio_webhook_url, params, twilio_signature)
      save_webhook_payload
    else
      head :unauthorized
    end
  end

  def save_webhook_payload
    @webhook_payload ||= WebhookPayload.create!(body: request.request_parameters.to_json)
  end
end
