module Twilio
  class ApiClient
    include Rails.application.routes.url_helpers

    def initialize(
      account:,
      delivery_method: :whatsapp,
      api_account_sid: ENV.fetch("TWILIO_ACCOUNT_SID"),
      api_auth_token: ENV.fetch("TWILIO_AUTH_TOKEN"),
      technovation_phone_number: ENV.fetch("TWILIO_PHONE_NUMBER"),
      host: ENV.fetch("HOST_DOMAIN"),
      logger: Rails.logger,
      error_notifier: Airbrake,
      secondary_error_notifier: IntegrationErrorNotifier
    )

      @account = account
      @delivery_method = delivery_method
      @api_account_sid = api_account_sid
      @api_auth_token = api_auth_token
      @technovation_phone_number = technovation_phone_number
      @host = host
      @logger = logger
      @error_notifier = error_notifier
      @secondary_error_notifier = secondary_error_notifier
      @client = Twilio::REST::Client.new(api_account_sid, api_auth_token)
    end

    def send_parental_consent_text_message
      consent_url = edit_parental_consent_url(
        token: consent_token,
        notification_method: "text_message",
        host: host
      )

      send_text_message(
        content_sid: ENV.fetch("TWILIO_PARENTAL_CONSENT_CONTENT_SID"),
        content_variables: {
          "1" => parent_guardian_name,
          "2" => student_name,
          "3" => consent_url
        },
        message_type: :parental_consent,
      )
    end

    def send_signed_consent_text_message(message_type:)
      signed_consents_url = signed_consents_url(
        token: consent_token,
        host: host
      )

      content_sid = message_type == :signed_parental_consent ?
        ENV.fetch("TWILIO_SIGNED_PARENTAL_CONSENT_CONTENT_SID") :
        ENV.fetch("TWILIO_SIGNED_MEDIA_CONSENT_CONTENT_SID")

      send_text_message(
        content_sid: content_sid,
        content_variables: {
          "1" => parent_guardian_name,
          "2" => student_name,
          "3" => signed_consents_url
        },
        message_type: message_type,
      )
    end

    private

    attr_reader :account, :delivery_method, :client, :api_account_sid, :api_auth_token, :technovation_phone_number, :host, :logger, :error_notifier, :secondary_error_notifier

    def consent_token
      account.consent_token
    end

    def parent_guardian_name
      account.student_profile.parent_guardian_name
    end

    def student_name
      account.student_profile.full_name
    end

    def parent_guardian_phone_number
      account.student_profile.parent_guardian_phone_number
    end

    def send_text_message(content_sid:, content_variables:, message_type:)
      prefix = delivery_method == :whatsapp ? "whatsapp:" : ""

      response = client.messages.create(
        content_sid: content_sid,
        content_variables: content_variables.to_json,
        to: "#{prefix}#{parent_guardian_phone_number}",
        from: "#{prefix}#{technovation_phone_number}",
        messaging_service_sid: ENV.fetch("TWILIO_MESSAGING_SERVICE_ID")
      )

      account.text_messages.create(
        delivery_method: delivery_method,
        status: response.status,
        message_type: message_type,
        external_message_id: response.sid,
        recipient: response.to,
        sent_at: Time.now,
        season: Season.current.year
      )
    rescue => error
      handle_error(error)
    end

    def handle_error(error)
      error_message = "[TWILIO] Error sending text message - #{error.message}"

      logger.error(error_message)
      error_notifier.notify(error_message)
      secondary_error_notifier.with(error_message:).deliver
    end
  end
end
