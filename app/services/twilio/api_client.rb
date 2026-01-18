module Twilio
  class ApiClient
    include Rails.application.routes.url_helpers

    def initialize(
      api_account_sid: ENV.fetch("TWILIO_ACCOUNT_SID"),
      api_auth_token: ENV.fetch("TWILIO_AUTH_TOKEN"),
      technovation_phone_number: ENV.fetch("TWILIO_PHONE_NUMBER"),
      host: ENV.fetch("HOST_DOMAIN"),
      logger: Rails.logger,
      error_notifier: Airbrake,
      secondary_error_notifier: IntegrationErrorNotifier
    )

      @api_account_sid = api_account_sid
      @api_auth_token = api_auth_token
      @technovation_phone_number = technovation_phone_number
      @host = host
      @logger = logger
      @error_notifier = error_notifier
      @secondary_error_notifier = secondary_error_notifier
      @client = Twilio::REST::Client.new(api_account_sid, api_auth_token)
    end

    def send_parental_consent_text_message(account:, delivery_method:)
      token = account.consent_token
      consent_url = edit_parental_consent_url(
        token: token,
        source: "text_message",
        host: host
      )

      parent_guardian_name = account.student_profile.parent_guardian_name
      student_name = account.student_profile.full_name
      message_body = "Hi #{parent_guardian_name}, #{student_name} has registered for the Technovation Girls program. " \
        "In order for her to participate, please click this link to complete the consent and media forms. #{consent_url}"

      send_text_message(
        account: account,
        message_body: message_body,
        message_type: :parental_consent,
        delivery_method: delivery_method
      )
    end

    def send_signed_consent_text_message(account:, message_type:, delivery_method:)
      token = account.consent_token
      signed_consents_url = signed_consents_url(
        token: token,
        host: host
      )

      consent_type = message_type == :signed_parental_consent ? "parental" : "media"
      parent_guardian_name = account.student_profile.parent_guardian_name
      student_name = account.student_profile.full_name
      message_body = "Hi #{parent_guardian_name}, thank you for signing the #{consent_type} consent for #{student_name}. " \
        "View your signed forms here: #{signed_consents_url}"

      send_text_message(
        account: account,
        message_body: message_body,
        message_type: message_type,
        delivery_method: delivery_method
      )
    end

    private

    attr_reader :client, :api_account_sid, :api_auth_token, :technovation_phone_number, :host, :logger, :error_notifier, :secondary_error_notifier

    Result = Struct.new(:success?, :response, :error, keyword_init: true)

    def send_text_message(account:, message_body:, message_type:, delivery_method: :whatsapp)
      parent_guardian_phone_number = account.student_profile.parent_guardian_phone_number

      result = if delivery_method == :sms
       send_sms_message(recipient_phone_number: parent_guardian_phone_number, message_body: message_body)
      else
       send_whatsapp_message(recipient_phone_number: parent_guardian_phone_number, message_body: message_body)
      end

      if result.success?
        account.text_messages.create(
          delivery_method: delivery_method,
          status: result.response.status,
          message_type: message_type,
          external_message_id: result.response.sid,
          recipient: result.response.to,
          sent_at: Time.now,
          season: Season.current.year
        )
      else
        handle_error(result.error)
      end
    end

    def send_whatsapp_message(recipient_phone_number:, message_body:)
      response = client.messages.create(
        body: message_body,
        to: "whatsapp:#{recipient_phone_number}",
        from: "whatsapp:#{ENV['TWILIO_WHATSAPP_PHONE_NUMBER']}"
      )

      Result.new(success?: true, response: response)
    rescue => error
      Result.new(success?: false, error: error)
    end

    def send_sms_message(recipient_phone_number:, message_body:)
      response = client.messages.create(
        body: message_body,
        to: recipient_phone_number,
        from: technovation_phone_number,
        messaging_service_sid: ENV.fetch("TWILIO_MESSAGING_SERVICE_ID")
      )

      Result.new(success?: true, response: response)
    rescue => error
      Result.new(success?: false, error: error)
    end

    def handle_error(error)
      error_message = "[TWILIO] Error sending text message - #{error.message}"

      logger.error(error_message)
      error_notifier.notify(error_message)
      secondary_error_notifier.with(error_message:).deliver
    end
  end
end
