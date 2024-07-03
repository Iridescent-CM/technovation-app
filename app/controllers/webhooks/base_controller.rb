class Webhooks::BaseController < ApplicationController
  skip_forgery_protection

  before_action :verify_webhook_payload, only: :create

  private

  def verify_webhook_payload
    raise NotImplementedError, "All webhook controllers must implement this functionality"
  end

  def save_webhook_payload
    @webhook_payload ||= WebhookPayload.create!(body: request.body.read)
  end
end
