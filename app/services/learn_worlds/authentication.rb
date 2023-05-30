module LearnWorlds
  class Authentication
    def initialize(
      client_id: ENV.fetch("LEARNWORLDS_API_CLIENT_ID"),
      client_secret: ENV.fetch("LEARNWORLDS_API_CLIENT_SECRET"),
      http_client: Faraday,
      logger: Rails.logger,
      error_notifier: Airbrake
    )

      @client = http_client.new(
        url: ENV.fetch("LEARNWORLDS_API_BASE_URL"),
        headers: {
          "Lw-Client" => client_id
        }
      )
      @client_id = client_id
      @client_secret = client_secret
      @logger = logger
      @error_notifier = error_notifier
    end

    def access_token(force_cache_refresh: false)
      Rails.cache.fetch(:learn_worlds_access_token, force: force_cache_refresh) do
        result = get_access_token

        result.access_token if result.success?
      end
    end

    def refresh_access_token
      access_token(force_cache_refresh: true)
    end

    private

    attr_reader :client, :client_id, :client_secret, :logger, :error_notifier

    Result = Struct.new(:success?, :message, :access_token, keyword_init: true)

    def get_access_token
      response = client.post(
        "oauth2/access_token",
        {client_id: client_id, client_secret: client_secret, grant_type: "client_credentials"}
      )

      response_body = JSON.parse(response.body, symbolize_names: true)

      if response_body[:success] == true
        Result.new(success?: true, access_token: response_body[:tokenData][:access_token])
      else
        response_body[:errors].each do |error|
          error = "[LEARNWORLDS] Error getting an access token - #{error}"

          logger.error(error)
          error_notifier.notify(error)
        end

        Result.new(success?: false, message: "There was an error trying to get an access token, please check the logs for more info.")
      end
    end
  end
end
