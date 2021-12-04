module LearnWorlds
  class ApiClient
    def initialize(
      client_id: ENV.fetch("LEARNWORLDS_CLIENT_ID"),
      access_token: Authentication.new.access_token,
      http_client: Faraday,
      logger: Rails.logger
    )

      @client = http_client.new(
        url: "https://api-lw9.learnworlds.com",
        headers: {
          "Lw-Client" => client_id,
          "Authorization" => "Bearer #{access_token}"
        }
      )
      @logger = logger
    end

    def sso(account:)
      response = client.post("/sso", request_body_for(account))
      response_body = JSON.parse(response.body, symbolize_names: true)

      if response_body[:success] == true
        if account.learn_worlds_user_id.blank?
          account.update_attribute(:learn_worlds_user_id, response_body[:user_id])
        end

        Result.new(success?: true, redirect_url: response_body[:url])
      else
        response_body[:errors].each do |error|
          logger.error("[LEARNWORLDS ERROR] #{error}")
        end

        Authentication.new.refresh_access_token

        Result.new(success?: false)
      end
    end

    private

    attr_reader :client, :logger

    Result = Struct.new(:success?, :message, :redirect_url, keyword_init: true)

    def request_body_for(account)
      if account.learn_worlds_user_id.present?
        {user_id: account.learn_worlds_user_id}
      else
        {
          email: account.email,
          username: account.first_name,
          avatar: ActionController::Base.helpers.image_url(account.avatar)
        }
      end.merge({
        redirectUrl: "https://beginner.technovationchallenge.org"
      })
    end
  end
end
