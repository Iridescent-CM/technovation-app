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

    def send_parental_consent_text_message(account:)
      token = account.consent_token
      consent_url = edit_parental_consent_url(
        token: token,
        host: host
      )

      parent_guardian_name = account.student_profile.parent_guardian_name
      parent_guardian_phone_number = account.student_profile.parent_guardian_phone_number
      student_name = account.student_profile.full_name
      message_body = "Hi #{parent_guardian_name}, #{student_name} has registered for the Technovation Girls program. " \
        "In order for her to participate, please click this link to complete the consent and media forms. #{consent_url}"

      begin
        response = client.messages.create(
          body: message_body,
          to: parent_guardian_phone_number,
          from: technovation_phone_number
        )

        account.text_messages.create(
          delivery_method: :sms,
          message_type: :parental_consent,
          external_message_id: response.sid,
          recipient: response.to,
          sent_at: Time.now,
          season: Season.current.year
        )
      rescue => error
        error_message = "[TWILIO] Error sending SMS - #{error.message}"

        logger.error(error_message)
        error_notifier.notify(error_message)
        secondary_error_notifier.with(error_message:).deliver
      end
    end

    private

    attr_reader :client, :api_account_sid, :api_auth_token, :technovation_phone_number, :host, :logger, :error_notifier, :secondary_error_notifier
  end
end
