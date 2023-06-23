module LearnWorlds
  class ApiClient
    def initialize(
      client_id: ENV.fetch("LEARNWORLDS_API_CLIENT_ID"),
      base_url: ENV.fetch("LEARNWORLDS_API_BASE_URL"),
      authentication_service: LearnWorlds::Authentication.new,
      http_client: Faraday,
      logger: Rails.logger,
      error_notifier: Airbrake
    )

      @client = http_client.new(
        url: base_url,
        headers: {
          "Lw-Client" => client_id,
          "Authorization" => "Bearer #{authentication_service.access_token}"
        }
      )
      @authentication_service = authentication_service
      @logger = logger
      @error_notifier = error_notifier
    end

    def sso(account:)
      response = client.post("sso", request_body_for(account))
      response_body = JSON.parse(response.body, symbolize_names: true)

      if response_body[:success] == true
        if account.learn_worlds_user_id.blank?
          learn_worlds_user_id = response_body[:user_id]

          account.update_attribute(:learn_worlds_user_id, learn_worlds_user_id)

          enroll_response = client.post(
            "v2/users/#{learn_worlds_user_id}/enrollment",
            {productId: "beginners", productType: "course", justification: "Auto-enrollment", price: 0.00}.to_json,
            "Content-Type" => "application/json"
          )

          enroll_response_body = JSON.parse(enroll_response.body, symbolize_names: true)

          if enroll_response_body[:success] == true
            Result.new(success?: true, redirect_url: response_body[:url])
          else
            error = "[LEARNWORLDS] Error performing auto-enrollment for account #{account.id} - #{enroll_response_body[:error]}"

            logger.error(error)
            error_notifier.notify(error)

            Result.new(success?: false)
          end
        else
          Result.new(success?: true, redirect_url: response_body[:url])
        end
      else
        response_body[:errors].each do |error|
          error = "[LEARNWORLDS] Error performing SSO for account #{account.id} - #{error}"

          logger.error(error)
          error_notifier.notify(error)
        end

        authentication_service.refresh_access_token

        Result.new(success?: false)
      end
    end

    private

    attr_reader :client, :authentication_service, :logger, :error_notifier

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
