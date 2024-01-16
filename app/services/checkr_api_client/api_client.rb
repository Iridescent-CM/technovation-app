module CheckrApiClient
  class ApiClient
    def initialize(
      candidate:,
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
      @candidate_id = candidate.background_check.candidate_id
    end

    def request_checkr_invitation
      if candidate_id.blank?
        candidate_resp = create_checkr_candidate
        candidate_resp_body = JSON.parse(candidate_resp.body, symbolize_names: true)

        if candidate_resp.success?
          @candidate_id = candidate_resp_body[:id]
        else
          error = candidate_resp_body[:error].join(", ")
          handle_error(error)
        end
      end

      if candidate_id.present?
        invitation_resp = create_checkr_invitation(
          candidate_country_code: candidate.country_code,
          candidate_id: candidate_id
        )

        invitation_resp_body = JSON.parse(invitation_resp.body, symbolize_names: true)

        if invitation_resp.success?
          candidate.background_check.update(
            candidate_id: candidate_id,
            invitation_id: invitation_resp_body[:id],
            invitation_status: invitation_resp_body[:status],
            invitation_url: invitation_resp_body[:invitation_url],
            internal_invitation_status: :invitation_sent,
            error_message: nil
          )
        else
          error = invitation_resp_body[:error]
          handle_error(error)
        end
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

    def create_checkr_candidate
      req_body = {
        email: candidate.email,
        first_name: candidate.first_name,
        last_name: candidate.last_name,
        dob: candidate.date_of_birth,
        work_locations: [{country: candidate.country_code}]
      }

      post("candidates", req_body)
    end

    def create_checkr_invitation(candidate_country_code:, candidate_id:)
      req_body = {
        package: "international_basic_plus",
        candidate_id: candidate_id,
        work_locations: [{country: candidate_country_code}]
      }

      post("invitations", req_body)
    end

    def post(resource, body)
      connection.post("/v1/#{resource}") do |req|
        req.body = body.to_json
      end
    end

    def handle_error(error)
      candidate.background_check.update(
        internal_invitation_status: :error,
        error_message: error
      )

      log_error_msg = "[CHECKR] Error for account #{candidate.id} - #{error}"
      logger.error(log_error_msg)
      error_notifier.notify(log_error_msg)
    end
  end
end
