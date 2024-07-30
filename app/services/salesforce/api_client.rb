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

    def setup_account_for_current_season(account:, profile_type:)
      salesforce_contact_id = nil

      handle_request "Upserting account #{account.id}" do
        salesforce_contact_id = upsert_contact(account: account)
      end

      handle_request "Setting up account (#{account.id}) for current season" do
        client.insert!(
          "Program_Participant__c",
          {
            Contact__c: salesforce_contact_id,
            Platform_Participant_Id__c: account.id,
            Year__c: Season.current.year,
            Type__c: profile_type
          }.merge(
            initial_program_participant_info_for(
              profile_type: profile_type,
              account: account
            )
          )
        )
      end
    end

    def upsert_contact_info_for(account:)
      handle_request "Upserting account #{account.id}" do
        upsert_contact(account: account)
      end
    end

    private

    attr_reader :client, :salesforce_enabled, :logger, :error_notifier

    def upsert_contact(account:)
      client.upsert!(
        "Contact",
        "Platform_Participant_Id__c",
        Platform_Participant_Id__c: account.id,
        FirstName: account.first_name,
        LastName: account.last_name,
        Email: account.email,
        Birthdate: account.date_of_birth,
        MailingCity: account.city,
        MailingState: account.state_province,
        MailingCountry: account.country,
        Parent__c: account.student_profile&.parent_guardian_name,
        Parent_Guardian_Email__c: account.student_profile&.parent_guardian_email
      )
    end

    def initial_program_participant_info_for(profile_type:, account:)
      case profile_type
      when "student"
        {
          TG_Division__c: "#{account.division.name} Division"
        }
      when "mentor"
        {
          Mentor_Type__c: account.mentor_profile.mentor_types.pluck(:name).join(";")
        }
      else
        {}
      end
    end

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
