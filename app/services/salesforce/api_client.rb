module Salesforce
  class ApiClient
    include Rails.application.routes.url_helpers

    def initialize(
      account:,
      profile_type: nil,
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

      @account = account
      @profile_type = profile_type
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

    def setup_account_for_current_season
      salesforce_contact_id = nil

      handle_request "Upserting account #{account.id}" do
        salesforce_contact_id = upsert_contact
      end

      handle_request "Setting up account (#{account.id}) for current season" do
        client.insert!(
          "Program_Participant__c",
          {
            Contact__c: salesforce_contact_id,
            Platform_Participant_Id__c: account.id,
            Year__c: Season.current.year,
            Type__c: profile_type
          }.merge(initial_program_participant_info)
        )
      end
    end

    def upsert_contact_info
      handle_request "Upserting account #{account.id}" do
        upsert_contact
      end
    end

    def update_program_info(season: Season.current.year)
      return if season != Season.current.year

      program_participant_record = client.query("select Id from Program_Participant__c where Platform_Participant_Id__c = #{account.id} and Type__c = '#{profile_type}' and Year__c = '#{season}'")

      if program_participant_record.present?
        handle_request "Updating program participant info for #{account.id}" do
          client.update!(
            "Program_Participant__c",
            {
              Id: program_participant_record.first.Id
            }.merge(program_participant_info)
          )
        end
      end
    end

    private

    attr_reader :account, :profile_type, :client, :salesforce_enabled, :logger, :error_notifier

    def upsert_contact
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

    def initial_program_participant_info
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

    def program_participant_info
      case profile_type
      when "student"
        submission = account.student_profile.team.submission

        {
          Pitch_Video__c: submission.pitch_video_link,
          Project_Link__c: submission.present? ? project_url(submission) : "",
          Submitted_Project__c: submission.published_at.present? ? "Submitted" : "Did Not Submit",
          Team_Name__c: account.student_profile.team.name
        }
      when "mentor"
        initial_program_participant_info.merge(
          {
            Mentor_Team_Status__c: account.mentor_profile.current_teams.present? ? "On Team" : "Not On Team"
          }
        )
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
