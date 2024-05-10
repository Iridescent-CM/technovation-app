class Webhooks::BaseController < ApplicationController
  skip_forgery_protection

  before_action :save_webhook_payload, only: :create

  private

  def save_webhook_payload
    @webhook_payload ||= WebhookPayload.create!(body: request.body.read)
  end
end
