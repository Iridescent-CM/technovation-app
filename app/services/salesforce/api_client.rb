module Salesforce
  class ApiClient
    def initialize(
      url: ENV.fetch("SALESFORCE_INSTANCE_URL"),
      access_token: ENV.fetch("SALESFORCE_ACCESS_TOKEN"),
      version: ENV.fetch("SALESFORCE_API_VERSION"),
      enabled: ENV.fetch("SALESFORCE_ENABLED", false),
      client_constructor: Restforce,
      logger: Rails.logger,
      error_notifier: Airbrake
    )

      if enabled
        @client = client_constructor.new(
          oauth_token: access_token,
          instance_url: url,
          api_version: version
        )

        @logger = logger
        @error_notifier = error_notifier
      else
        logger.info "[SALESFORCE DISABLED] Trying to initialize Salesforce API client"

        raise "Salesforce is disabled"
      end
    end

    def add_contact(account:)
      salesforce_id = nil

      handle_request do
        salesforce_id = client.create!(
          "Contact",
          FirstName: account.first_name,
          LastName: account.last_name,
          Email: account.email
        )
      end

      if salesforce_id.present?
        account.update_attribute(:salesforce_id, salesforce_id)
      end
    end

    def update_contact(account:)
      if account.salesforce_id.present?
        handle_request do
          client.update!(
            "Contact",
            Id: account.salesforce_id,
            FirstName: account.first_name,
            LastName: account.last_name,
            Email: account.email
          )
        end
      end
    end

    def delete_contact(salesforce_id:)
      if salesforce_id.present?
        handle_request do
          client.destroy!("Contact", salesforce_id)
        end
      end
    end

    private

    attr_reader :client, :logger, :error_notifier

    def handle_request(&block)
      block.call
    rescue => error
      logger.error("[SALESFORCE] #{error}")
      error_notifier.notify("[SALESFORCE] #{error}")
    end
  end
end
