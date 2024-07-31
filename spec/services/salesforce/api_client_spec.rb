require "rails_helper"

RSpec.describe Salesforce::ApiClient do
  let(:salesforce_api_client) do
    Salesforce::ApiClient.new(
      account: account,
      profile_type: profile_type,
      instance_url: salesforce_instance_url,
      host: salesforce_host,
      api_version: salesforce_api_version,
      client_id: salesforce_client_id,
      client_secret: salesforce_client_secret,
      refresh_token: salesforce_refresh_token,
      oauth_token: salesforce_oauth_token,
      authentication_callback: salesforce_authentication_callback,
      enabled: salesforce_enabled,
      client_constructor: client_constructor,
      logger: logger,
      error_notifier: error_notifier
    )
  end

  let(:salesforce_instance_url) { "https://test-salesforce.com/" }
  let(:salesforce_host) { "test.salesforce.com" }
  let(:salesforce_api_version) { "60" }
  let(:salesforce_client_id) { "1234-09876-5432" }
  let(:salesforce_client_secret) { "8766-qwerty-54321" }
  let(:salesforce_oauth_token) { "aaaaa-bbbb-ccc" }
  let(:salesforce_refresh_token) { "11111-22222-3333333" }
  let(:salesforce_authentication_callback) { double("authentication_callback") }
  let(:salesforce_enabled) { true }
  let(:client_constructor) { class_double(Restforce).as_stubbed_const }
  let(:logger) { double("Logger") }
  let(:error_notifier) { double("Airbrake") }

  before do
    allow(client_constructor).to receive(:new).with(
      instance_url: salesforce_instance_url,
      host: salesforce_host,
      api_version: salesforce_api_version,
      client_id: salesforce_client_id,
      client_secret: salesforce_client_secret,
      refresh_token: salesforce_refresh_token,
      oauth_token: salesforce_oauth_token,
      authentication_callback: salesforce_authentication_callback
    ).and_return(salesforce_client)

    allow(logger).to receive(:info)
    allow(logger).to receive(:error)
    allow(error_notifier).to receive(:notify)
  end

  let(:salesforce_client) { double("SalesforceClent") }
  let(:student_profile) { FactoryBot.build(:student_profile) }
  let(:account) { student_profile.account }
  let(:profile_type) { "student" }

  describe "#setup_account_for_current_season" do
    before do
      allow(salesforce_client).to receive(:upsert!).and_return(salesforce_contact_id)
      allow(salesforce_client).to receive(:insert!)
    end

    let(:salesforce_contact_id) { 192837 }
    let(:profile_type) { "student" }

    context "when Salesforce is enabled" do
      let(:salesforce_enabled) { true }

      it "calls the upsert! method to create a new contact in Salesforce" do
        expect(salesforce_client).to receive(:upsert!)

        salesforce_api_client.setup_account_for_current_season
      end

      it "calls the insert! method to create a new 'program participant' in Salesforce" do
        expect(salesforce_client).to receive(:insert!)

        salesforce_api_client.setup_account_for_current_season
      end

      context "when setting up a student" do
        let(:student_profile) { FactoryBot.build(:student_profile) }
        let(:account) { student_profile.account }
        let(:profile_type) { "student" }

        it "calls the insert! method to create a new 'program participant' record and includes student info" do
          expect(salesforce_client).to receive(:insert!).with(
            "Program_Participant__c",
            {
              Contact__c: salesforce_contact_id,
              Platform_Participant_Id__c: account.id,
              Year__c: Season.current.year,
              Type__c: profile_type,
              TG_Division__c: "#{student_profile.division.name} Division"
            }
          )

          salesforce_api_client.setup_account_for_current_season
        end
      end

      context "when setting up a mentor" do
        let(:mentor_profile) { FactoryBot.build(:mentor_profile) }
        let(:account) { mentor_profile.account }
        let(:profile_type) { "mentor" }

        it "calls the insert! method to create a new 'program participant' record and includes mentor info" do
          expect(salesforce_client).to receive(:insert!).with(
            "Program_Participant__c",
            {
              Contact__c: salesforce_contact_id,
              Platform_Participant_Id__c: account.id,
              Year__c: Season.current.year,
              Type__c: profile_type,
              Mentor_Type__c: mentor_profile.mentor_types.pluck(:name).join(";")
            }
          )

          salesforce_api_client.setup_account_for_current_season
        end
      end
    end
  end

  describe "#upsert_contact_info" do
    context "when Salesforce is enabled" do
      let(:salesforce_enabled) { true }
    end

    it "calls the upsert! method to upsert a new contact in Salesforce" do
      expect(salesforce_client).to receive(:upsert!).with(
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
        Parent__c: account.student_profile.parent_guardian_name,
        Parent_Guardian_Email__c: account.student_profile.parent_guardian_email
      )

      salesforce_api_client.upsert_contact_info
    end

    context "when the upsert! was unsuccessful" do
      before do
        allow(salesforce_client).to receive(:upsert!).and_raise(error_message)
      end

      let(:error_message) { "UPSERT CONTACT ERROR" }

      it "logs the error" do
        expect(logger).to receive(:error).with("[SALESFORCE] #{error_message}")

        salesforce_api_client.upsert_contact_info
      end

      it "notifies the error_notifier with the error" do
        expect(error_notifier).to receive(:notify).with("[SALESFORCE] #{error_message}")

        salesforce_api_client.upsert_contact_info
      end
    end

    context "when Salesforce is disabled" do
      let(:salesforce_enabled) { false }

      it "logs an error" do
        expect(logger).to receive(:info).with("[SALESFORCE DISABLED] Upserting account #{account.id}")

        salesforce_api_client.upsert_contact_info
      end
    end

    context "when Salesforce is disabled via a 'false' string setting" do
      let(:salesforce_enabled) { "false" }

      it "logs an error" do
        expect(logger).to receive(:info).with("[SALESFORCE DISABLED] Upserting account #{account.id}")

        salesforce_api_client.upsert_contact_info
      end
    end
  end

  describe "#update_program_info" do
    before do
      allow(salesforce_client).to receive(:query).and_return(program_participants)
      allow(salesforce_client).to receive(:insert!)
    end

    let(:program_participants) { [double("salesforce_program_participant", Id: program_participant_id)] }

    context "when Salesforce is enabled" do
      let(:salesforce_enabled) { true }

      context "when a program participant record exists in Salesforce" do
        let(:program_participant_id) { 42555 }

        it "calls update! to update program participant info in Salesforce" do
          expect(salesforce_client).to receive(:update!)

          salesforce_api_client.update_program_info
        end

        context "when setting up a mentor" do
          let(:mentor_profile) { FactoryBot.build(:mentor_profile) }
          let(:account) { mentor_profile.account }
          let(:profile_type) { "mentor" }

          it "calls update! to update the 'program participant' info for the mentor" do
            expect(salesforce_client).to receive(:update!).with(
              "Program_Participant__c",
              {
                Id: program_participant_id,
                Mentor_Type__c: mentor_profile.mentor_types.pluck(:name).join(";"),
                Mentor_Team_Status__c: "Not On Team"
              }
            )

            salesforce_api_client.update_program_info
          end
        end
      end

      context "when a program participant record doesn't exist in Salesforce" do
        let(:program_participant_id) { nil }

        it "does not call update! to update program participant info in Salesforce" do
          expect(salesforce_client).not_to receive(:update!)

          salesforce_api_client.update_program_info
        end
      end
    end
  end
end
