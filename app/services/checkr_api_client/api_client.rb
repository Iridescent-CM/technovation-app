module CheckrApiClient
  class ApiClient
    def initialize(
      client_id: ENV.fetch("CHECKR_API_KEY"),
      base_url: ENV.fetch("CHECKR_API_BASE", "https://api.checkr.com"),
      logger: Rails.logger,
      error_notifier: Airbrake
    )

      @connection = Faraday.new(
        url: base_url,
        headers: {"Content-Type" => "application/json"}
      ) do |conn|
        conn.request :authorization, :basic, client_id, ""
      end

      @logger = logger
      @error_notifier = error_notifier
    end

    def request_checkr_invitation(candidate:)
      candidate_response = connection.post("/v1/candidates") do |req|
        req.body = {
          email: candidate.account.email,
          first_name: candidate.account.first_name,
          last_name: candidate.account.last_name,
          dob: candidate.account.date_of_birth,
          work_locations: [{country: candidate.account.country_code}]
        }.to_json
      end

      candidate_response_body = JSON.parse(candidate_response.body, symbolize_names: true)

      if candidate_response.success?
        invitation_response = connection.post("/v1/invitations") do |req|
          req.body = {
            package: "international_basic_plus",
            candidate_id: candidate_response_body[:id],
            work_locations: [{country: candidate.account.country_code}]
          }.to_json
        end

        invitation_response_body = JSON.parse(invitation_response.body, symbolize_names: true)

        if invitation_response.success?
          candidate.account.update(background_check_attributes: {
            candidate_id: candidate_response_body[:id],
            invitation_id: invitation_response_body[:id],
            invitation_status: invitation_response_body[:status],
            status: :invitation_sent
          })

          Result.new(success?: true)

        else
          error = "[CHECKR] Error requesting invitation for #{candidate.account.id} - #{invitation_response_body[:error]}"
          logger.error(error)
          error_notifier.notify(error)

          Result.new(success?: false)
        end
      else
        error = "[CHECKR] Error creating candidate for #{candidate.account.id} - #{candidate_response_body[:error]}"
        logger.error(error)
        error_notifier.notify(error)

        Result.new(success?: false)
      end
    end

    def retrieve_invitation(invitation_id)
      invitation_response = connection.get("/v1/invitations/#{invitation_id}")

      invitation_response_body = JSON.parse(invitation_response.body, symbolize_names: true)

      if invitation_response.success?
        Result.new(success?: true, payload: invitation_response_body)
      else
        error = "[CHECKR] Error requesting invitation for #{invitation_id} - #{invitation_response_body[:error]}"
        logger.error(error)
        error_notifier.notify(error)

        Result.new(success?: false)
      end
    end

    private

    attr_reader :connection, :logger, :error_notifier

    Result = Struct.new(:success?, :message, :payload, keyword_init: true)
  end
end
