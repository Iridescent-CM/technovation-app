class ProcessTwilioWebhookPayloadJob < ActiveJob::Base
  queue_as :default

  def perform(
    webhook_payload_id:,
    logger: Rails.logger,
    error_notifier: Airbrake
  )

    webhook_payload = WebhookPayload.find(webhook_payload_id)
    parsed_payload = JSON.parse(webhook_payload.body, symbolize_names: true)
    message_sid = parsed_payload[:MessageSid]
    message_status = parsed_payload[:MessageStatus]
    channel_prefix = parsed_payload[:ChannelPrefix]
    error_code = parsed_payload[:ErrorCode]
    error_message = parsed_payload[:ErrorMessage]
    text_message = TextMessage.find_by(external_message_id: message_sid)

    if text_message.present? && message_status != text_message.status
      text_message_type = text_message.message_type.to_sym

      text_message.update(
        status: message_status,
        error_code: error_code,
        error_message: error_message
      )

      if message_status == "failed" && channel_prefix == "whatsapp"
        if text_message_type == :parental_consent
          SendParentalConsentTextMessageJob.perform_later(
            account_id: text_message.account_id,
            delivery_method: :sms
          )
        elsif text_message_type == :signed_parental_consent || text_message_type == :signed_media_consent
          SendSignedConsentTextMessageJob.perform_later(
            account_id: text_message.account_id,
            message_type: text_message_type,
            delivery_method: :sms
          )
        end
      end

      webhook_payload.delete if message_status == "delivered"
    else
      error = "[TWILIO WEBHOOK] Couldn't process payload with external message id: #{message_sid}"

      logger.error(error)
      error_notifier.notify(error)
    end
  end
end
