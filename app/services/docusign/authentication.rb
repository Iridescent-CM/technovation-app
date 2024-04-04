module Docusign
  class Authentication
    def initialize(
      integration_id: ENV.fetch("DOCUSIGN_INTEGRATION_ID"),
      client_secret: ENV.fetch("DOCUSIGN_CLIENT_SECRET"),
      authorization_code: ENV.fetch("DOCUSIGN_AUTHORIZATION_CODE"),
      base_url: ENV.fetch("DOCUSIGN_AUTHORIZATION_BASE_URL"),
      http_client: Faraday,
      logger: Rails.logger,
      error_notifier: Airbrake
    )

      @client = http_client.new(
        url: base_url,
        headers: {
          "Authorization" => "Basic #{Base64.encode64(integration_id + ":" + client_secret).delete("\r\n")}"
        }
      )
      @authorization_code = authorization_code
      @logger = logger
      @error_notifier = error_notifier
    end

    def access_token(force_cache_refresh: false)
      Rails.cache.fetch(:docusign_access_token, force: force_cache_refresh) do
        result = if authorization_code.present?
          get_access_token_from_authorization_code
        elsif Rails.cache.read(:docusign_refresh_token).present?
          get_access_token_from_refresh_token
        else
          error = "[DOCUSIGN] An authorization code or refresh token is required to obtain an access token"

          logger.error(error)
          error_notifier.notify(error)

          Result.new(success?: false, message: error)
        end

        result.access_token if result.success?
      end
    end

    def refresh_access_token
      access_token(force_cache_refresh: true)
    end

    private

    attr_reader :client, :authorization_code, :logger, :error_notifier

    Result = Struct.new(:success?, :message, :access_token, keyword_init: true)

    def get_access_token_from_authorization_code
      response = client.post(
        "oauth/token",
        {grant_type: "authorization_code", code: authorization_code}
      )

      process_response(response)
    end

    def get_access_token_from_refresh_token
      response = client.post(
        "oauth/token",
        {grant_type: "refresh_token", refresh_token: Rails.cache.read(:docusign_refresh_token)}
      )

      process_response(response)
    end

    def process_response(response)
      response_body = JSON.parse(response.body, symbolize_names: true)

      if response_body[:access_token].present?
        Rails.cache.write(:docusign_refresh_token, response_body[:refresh_token])

        Result.new(success?: true, access_token: response_body[:access_token])
      else
        error = "[DOCUSIGN] Error getting an access token - #{response_body[:error]}"

        logger.error(error)
        error_notifier.notify(error)

        Result.new(success?: false, message: "There was an error trying to get an access token, please check the logs for more info.")
      end
    end
  end
end
