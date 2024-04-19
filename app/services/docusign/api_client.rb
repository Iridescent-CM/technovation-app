module Docusign
  class ApiClient
    def initialize(
      api_account_id: ENV.fetch("DOCUSIGN_API_ACCOUNT_ID"),
      base_url: ENV.fetch("DOCUSIGN_API_BASE_URL"),
      authentication_service: Docusign::Authentication.new,
      http_client: Faraday,
      logger: Rails.logger,
      error_notifier: Airbrake
    )

      @client = http_client.new(
        url: base_url,
        headers: {
          "Authorization" => "Bearer #{authentication_service.access_token}",
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        }
      )
      @api_account_id = api_account_id
      @logger = logger
      @error_notifier = error_notifier
    end

    def send_memorandum_of_understanding(
      full_name:,
      email_address:,
      organization_name:,
      job_title: nil
    )

      response = client.post(
        "v2.1/accounts/#{api_account_id}/envelopes",
        {
          templateId: ENV.fetch("DOCUSIGN_MEMORANDUM_OF_UNDERSTANDING_TEMPLATE_ID"),
          templateRoles: [
            {
              name: full_name,
              email: email_address,
              roleName: "signer",
              tabs: {
                textTabs: [
                  {
                    documentId: 1,
                    pageNumber: 1,
                    required: true,
                    font: "Georgia",
                    fontSize: "Size10",
                    italic: true,
                    underline: true,
                    value: full_name,
                    width: 100,
                    height: 23,
                    xPosition: 394,
                    yPosition: 152
                  },
                  {
                    documentId: 1,
                    pageNumber: 1,
                    font: "Georgia",
                    fontSize: "Size10",
                    italic: true,
                    underline: true,
                    value: organization_name,
                    width: 12,
                    height: 23,
                    xPosition: 98,
                    yPosition: 180
                  },
                  {
                    anchorString: "Name of Organization (if applicable):",
                    anchorXOffset: 190,
                    anchorYOffset: -11,
                    font: "Georgia",
                    fontSize: "Size12",
                    value: organization_name,
                    width: 200
                  },
                  {
                    anchorString: "Title:",
                    anchorXOffset: 30,
                    anchorYOffset: -11,
                    font: "Georgia",
                    fontSize: "Size12",
                    required: false,
                    value: job_title,
                    width: 155
                  }
                ],
                signHereTabs: [
                  {
                    anchorString: "Signature:",
                    anchorXOffset: 65,
                    anchorYOffset: -7
                  }
                ],
                dateSignedTabs: [
                  {
                    anchorString: "Date:",
                    anchorXOffset: 30,
                    anchorYOffset: -10,
                    font: "Georgia",
                    fontSize: "Size12"
                  }
                ],
                fullNameTabs: [
                  {
                    anchorString: "Name:",
                    anchorXOffset: 35,
                    anchorYOffset: -9,
                    font: "Georgia",
                    fontSize: "Size12"
                  }
                ]
              }
            }
          ],
          status: "sent"
        }.to_json
      )

      response_body = JSON.parse(response.body, symbolize_names: true)

      if response.success?
        Result.new(success?: true)
      else
        error = "[DOCUSIGN] Error sending MOU - #{response_body[:error]}"

        logger.error(error)
        error_notifier.notify(error)

        Result.new(success?: false, message: "There was an error trying to send the MOU, please check the logs for more info.")
      end
    end

    private

    attr_reader :client, :api_account_id, :logger, :error_notifier

    Result = Struct.new(:success?, :message, keyword_init: true)
  end
end
