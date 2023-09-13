module CustomCheckr
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

    def request_checkr_invitation(resource, profile:)
      candidate_response = connection.post("/v1/#{resource}") do |req|
        req.body = {
          email: profile.account.email,
          first_name: profile.account.first_name,
          last_name: profile.account.last_name,
          work_locations: [{country: profile.account.country_code}]
        }.to_json
      end

      candidate_response_body = JSON.parse(candidate_response.body, symbolize_names: true)

      if candidate_response.status == 201
        invitation_response = connection.post("/v1/invitations") do |req|
          req.body = {
            package: "international_basic_plus",
            candidate_id: candidate_response_body[:id],
            work_locations: [{country: profile.account.country_code}]
          }.to_json
        end

        invitation_response_body = JSON.parse(invitation_response.body, symbolize_names: true)

        if invitation_response.status == 201
          profile.account.update(background_check_attributes: {
            candidate_id: candidate_response_body[:id],
            report_id: "international",
            invitation_id: invitation_response_body[:id],
            invitation_status: invitation_response_body[:status],
            status: :invitation_sent
          })

          Result.new(success?: true)

        else
          error = "[CHECKR] Error requesting invitation for #{profile.account.id} - #{invitation_response_body[:error]}"
          logger.error(error)
          error_notifier.notify(error)

          Result.new(success?: false)
        end
      else
        error = "[CHECKR] Error creating candidate for #{profile.account.id} - #{candidate_response_body[:error]}"
        logger.error(error)
        error_notifier.notify(error)

        Result.new(success?: false)
      end
    end

    # todo: get request for invitation status update from checkr
    # def get_checkr_invitation()
    # end

    private

    attr_reader :connection, :logger, :error_notifier

    Result = Struct.new(:success?, :message, keyword_init: true)
  end
end
