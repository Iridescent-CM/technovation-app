module CheckrApiClient
  class ApiClient
    def initialize(
      candidate,
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
      @candidate = candidate
      @candidate_id = candidate.account.background_check.candidate_id
    end

    def request_checkr_invitation
      if candidate_id.blank?
        create_checkr_candidate(candidate: candidate)
      end

      if candidate_id.present?
        invitation_response = create_checkr_invitation(
          candidate_country_code: candidate.account.country_code,
          candidate_id: candidate_id
        )

        if invitation_response.success?
          candidate.account.update(background_check_attributes: {
            candidate_id: candidate_id,
            invitation_id: invitation_response.payload[:id],
            invitation_status: invitation_response.payload[:status],
            invitation_url: invitation_response.payload[:invitation_url],
            status: :invitation_sent
          })

          Result.new(success?: true)
        else
          error = "[CHECKR] Error requesting invitation for #{candidate.account.id} - #{invitation_response.payload[:error]}"
          logger.error(error)
          error_notifier.notify(error)

          Result.new(success?: false)
        end
      else
        error = "[CHECKR] Error requesting invitation for #{candidate.account.id} - Candidate ID is missing."
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

    attr_reader :connection, :logger, :error_notifier, :candidate_id, :candidate

    Result = Struct.new(:success?, :message, :payload, keyword_init: true)

    def create_checkr_candidate(candidate:)
      req_body = {
        email: candidate.account.email,
        first_name: candidate.account.first_name,
        last_name: candidate.account.last_name,
        dob: candidate.account.date_of_birth,
        work_locations: [{country: candidate.account.country_code}]
      }

      candidate_response = post("candidates", req_body)
      candidate_response_body = JSON.parse(candidate_response.body, symbolize_names: true)

      if candidate_response.success?
        @candidate_id = candidate_response_body[:id]
        Result.new(success?: true)
      else
        error = "[CHECKR] Error creating candidate for #{candidate.account.id} - #{candidate_response_body[:error]}"
        logger.error(error)
        error_notifier.notify(error)

        Result.new(success?: false)
      end
    end

    def create_checkr_invitation(candidate_country_code:, candidate_id:)
      req_body = {
        package: "international_basic_plus",
        candidate_id: candidate_id,
        work_locations: [{country: candidate_country_code}]
      }

      invitation_response = post("invitations", req_body)
      invitation_response_body = JSON.parse(invitation_response.body, symbolize_names: true)

      Result.new(success?: invitation_response.success?, payload: invitation_response_body)
    end

    def post(resource, body)
      connection.post("/v1/#{resource}") do |req|
        req.body = body.to_json
      end
    end
  end
end
