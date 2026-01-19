class Webhooks::BaseController < ApplicationController
  skip_forgery_protection

  before_action :verify_webhook_payload, only: :create

  private

  def verify_webhook_payload
    raise NotImplementedError, "All webhook controllers must implement this functionality"
  end

  def save_webhook_payload(payload = nil)
    body = payload || request.body.read
    @webhook_payload ||= WebhookPayload.create!(body: body)
  end
end
