require "rails_helper"

RSpec.describe Salesforce::ApiClient do
  let(:salesforce_api_client) do
    Salesforce::ApiClient.new(
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
  let(:account) do
    instance_double(
      Account,
      id: 45678,
      first_name: first_name,
      last_name: last_name,
      email: email,
      salesforce_id: salesforce_id
    )
  end
  let(:first_name) { "Luna" }
  let(:last_name) { "Lovegood" }
  let(:email) { "luna@example.com" }
  let(:salesforce_id) { 123 }

  describe "adding a new contact to Salesforce" do
    context "when Salesforce is enabled" do
      let(:salesforce_enabled) { true }
    end

    it "calls the create! method to create a new contact in Salesforce" do
      expect(salesforce_client).to receive(:create!).with(
        "Contact",
        FirstName: account.first_name,
        LastName: account.last_name,
        Email: account.email
      )

      salesforce_api_client.add_contact(account: account)
    end

    context "when create! was successful" do
      before do
        allow(salesforce_client).to receive(:create!).and_return(salesforce_id)
      end

      let(:salesforce_id) { "789122654" }

      it "saves the Salesforce ID to the account" do
        expect(account).to receive(:update_attribute).with(:salesforce_id, salesforce_id)

        salesforce_api_client.add_contact(account: account)
      end
    end

    context "when create! was unsuccessful" do
      before do
        allow(salesforce_client).to receive(:create!).and_raise(error_message)
      end

      let(:error_message) { "ADD CONTACT ERROR" }

      it "logs the error" do
        expect(logger).to receive(:error).with("[SALESFORCE] #{error_message}")

        salesforce_api_client.add_contact(account: account)
      end

      it "notifies the error_notifier with the error" do
        expect(error_notifier).to receive(:notify).with("[SALESFORCE] #{error_message}")

        salesforce_api_client.add_contact(account: account)
      end
    end

    context "when Salesforce is disabled" do
      let(:salesforce_enabled) { false }

      it "logs an error" do
        expect(logger).to receive(:info).with("[SALESFORCE DISABLED] Adding account #{account.id}")

        salesforce_api_client.add_contact(account: account)
      end
    end

    context "when Salesforce is disabled via a 'false' string setting" do
      let(:salesforce_enabled) { "false" }

      it "logs an error" do
        expect(logger).to receive(:info).with("[SALESFORCE DISABLED] Adding account #{account.id}")

        salesforce_api_client.add_contact(account: account)
      end
    end
  end

  describe "updating a contact in Salesforce" do
    context "when Salesforce is enabled" do
      let(:salesforce_enabled) { true }
    end

    context "when the account has a salesforce_id" do
      let(:salesforce_id) { "9876fghij54321" }

      it "calls the update! method to update the contact in Salesforce" do
        expect(salesforce_client).to receive(:update!).with(
          "Contact",
          Id: account.salesforce_id,
          FirstName: account.first_name,
          LastName: account.last_name,
          Email: account.email
        )

        salesforce_api_client.update_contact(account: account)
      end

      context "when update! was unsuccessful" do
        before do
          allow(salesforce_client).to receive(:update!).and_raise(error_message)
        end

        let(:error_message) { "UPDATE ERROR" }

        it "logs the error" do
          expect(logger).to receive(:error).with("[SALESFORCE] #{error_message}")

          salesforce_api_client.update_contact(account: account)
        end

        it "notifies the error_notifier with the error" do
          expect(error_notifier).to receive(:notify).with("[SALESFORCE] #{error_message}")

          salesforce_api_client.update_contact(account: account)
        end
      end
    end

    context "when the account does not have salesforce_id" do
      let(:salesforce_id) { nil }

      it "does not call the update! method" do
        expect(salesforce_client).not_to receive(:update!)

        salesforce_api_client.update_contact(account: account)
      end
    end

    context "when Salesforce is disabled" do
      let(:salesforce_enabled) { false }

      it "logs an error" do
        expect(logger).to receive(:info).with("[SALESFORCE DISABLED] Updating account #{account.id}")

        salesforce_api_client.update_contact(account: account)
      end
    end

    context "when Salesforce is disabled via a 'false' string setting" do
      let(:salesforce_enabled) { false }

      it "logs an error" do
        expect(logger).to receive(:info).with("[SALESFORCE DISABLED] Updating account #{account.id}")

        salesforce_api_client.update_contact(account: account)
      end
    end
  end

  describe "deleting a contact in Salesforce" do
    context "when Salesforce is enabled" do
      let(:salesforce_enabled) { true }
    end

    context "when the account has a salesforce_id" do
      let(:salesforce_id) { "rstuv34567wxy" }

      it "calls the destroy! method to delete the contact in Salesforce" do
        expect(salesforce_client).to receive(:destroy!).with("Contact", salesforce_id)

        salesforce_api_client.delete_contact(salesforce_id: salesforce_id)
      end

      context "when destroy! was unsuccessful" do
        before do
          allow(salesforce_client).to receive(:destroy!).and_raise(error_message)
        end

        let(:error_message) { "DESTROY ERROR" }

        it "logs the error" do
          expect(logger).to receive(:error).with("[SALESFORCE] #{error_message}")

          salesforce_api_client.delete_contact(salesforce_id: salesforce_id)
        end

        it "notifies the error_notifier with the error" do
          expect(error_notifier).to receive(:notify).with("[SALESFORCE] #{error_message}")

          salesforce_api_client.delete_contact(salesforce_id: salesforce_id)
        end
      end
    end

    context "when the account does not have salesforce_id" do
      let(:salesforce_id) { nil }

      it "does not call the destroy! method" do
        expect(salesforce_client).not_to receive(:destroy!)

        salesforce_api_client.delete_contact(salesforce_id: salesforce_id)
      end
    end

    context "when Salesforce is disabled" do
      let(:salesforce_enabled) { false }

      it "logs and raises an error" do
        expect(logger).to receive(:info).with("[SALESFORCE DISABLED] Deleting account with Salesforce Id #{salesforce_id}")

        salesforce_api_client.delete_contact(salesforce_id: salesforce_id)
      end
    end

    context "when Salesforce is disabled via a 'false' string setting" do
      let(:salesforce_enabled) { "false" }

      it "logs an error" do
        expect(logger).to receive(:info).with("[SALESFORCE DISABLED] Deleting account with Salesforce Id #{salesforce_id}")

        salesforce_api_client.delete_contact(salesforce_id: salesforce_id)
      end
    end
  end
end
