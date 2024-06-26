module Salesforce
  class ApiClient
    def initialize(
      enabled: ENV.fetch("ENABLE_SALESFORCE", false),
      instance_url: ENV.fetch("SALESFORCE_INSTANCE_URL"),
      host: ENV.fetch("SALESFORCE_HOST"),
      api_version: ENV.fetch("SALESFORCE_API_VERSION"),
      client_id: ENV.fetch("SALESFORCE_CLIENT_ID"),
      client_secret: ENV.fetch("SALESFORCE_CLIENT_SECRET"),
      refresh_token: ENV.fetch("SALESFORCE_REFRESH_TOKEN"),
      oauth_token: Rails.cache.fetch(:salesforce_access_token),
      authentication_callback: proc do |response|
        Rails.cache.write(:salesforce_access_token, response["access_token"])
      end,
      client_constructor: Restforce,
      logger: Rails.logger,
      error_notifier: Airbrake
    )

      @client = client_constructor.new(
        instance_url: instance_url,
        host: host,
        api_version: api_version,
        client_id: client_id,
        client_secret: client_secret,
        refresh_token: refresh_token,
        oauth_token: oauth_token,
        authentication_callback: authentication_callback
      )
      @salesforce_enabled = ActiveModel::Type::Boolean.new.cast(enabled)
      @logger = logger
      @error_notifier = error_notifier
    end

    def add_contact(account:)
      salesforce_id = nil

      handle_request "Adding account #{account.id}" do
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
        handle_request "Updating account #{account.id}" do
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
        handle_request "Deleting account with Salesforce Id #{salesforce_id}" do
          client.destroy!("Contact", salesforce_id)
        end
      end
    end

    private

    attr_reader :client, :salesforce_enabled, :logger, :error_notifier

    def handle_request(message, &block)
      if salesforce_enabled
        begin
          block.call
        rescue => error
          logger.error("[SALESFORCE] #{error}")
          error_notifier.notify("[SALESFORCE] #{error}")
        end
      else
        logger.info "[SALESFORCE DISABLED] #{message}"
      end
    end
  end
end
