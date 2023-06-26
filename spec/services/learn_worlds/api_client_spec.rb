require "rails_helper"

RSpec.describe LearnWorlds::ApiClient do
  let(:learn_worlds_api_client) do
    LearnWorlds::ApiClient.new(
      client_id: client_id,
      base_url: base_url,
      authentication_service: authentication_service,
      http_client: http_client,
      logger: logger,
      error_notifier: error_notifier
    )
  end

  let(:client_id) { "abcd_client_id" }
  let(:base_url) { "https://learn-worlds-base-url" }
  let(:authentication_service) { instance_double(LearnWorlds::Authentication, access_token: "test_token", refresh_access_token: true) }
  let(:http_client) { class_double(Faraday).as_stubbed_const }
  let(:http_client_instance) { double("Faraday instance") }
  let(:logger) { instance_double(ActiveSupport::Logger, error: true) }
  let(:error_notifier) { double("Airbrake") }

  before do
    allow(http_client).to receive(:new).with(
      url: base_url,
      headers: {
        "Lw-Client" => client_id,
        "Authorization" => "Bearer #{authentication_service.access_token}"
      }
    ).and_return(http_client_instance)

    allow(http_client_instance).to receive(:post).and_return(mock_learn_worlds_sso_response)
    allow(error_notifier).to receive(:notify)
    allow(ActionController::Base).to receive_message_chain(:helpers, :image_url).and_return(account.avatar)
  end

  let(:account) { instance_double(Account, learn_worlds_user_id: learn_worlds_user_id_on_account, email: "beginner123@test.com", first_name: "Beginner", avatar: "avatar.png", id: 1, update_attribute: true) }
  let(:learn_worlds_user_id_on_account) { nil }

  describe "#sso" do
    context "when the LearnWorlds SSO response is successful" do
      let(:mock_learn_worlds_sso_response) do
        double("mock_learn_worlds_sso_response",
          body: {
            success: true,
            url: "https://learnworlds-sso-url",
            user_id: "learn_worlds_user_id"
          }.to_json
        )
      end

      it "returns a successful result" do
        result = learn_worlds_api_client.sso(account: account)

        expect(result.success?).to eq(true)
      end

      it "returns a redirect_url in the success result" do
        result = learn_worlds_api_client.sso(account: account)

        expect(result.redirect_url).to eq("https://learnworlds-sso-url")
      end

      context "when the account does not have a learn_worlds_user_id" do
        let(:learn_worlds_user_id_on_account) { nil }

        it "updates the account with learn_worlds_user_id" do
          expect(account).to receive(:update_attribute).with(:learn_worlds_user_id, "learn_worlds_user_id")

          learn_worlds_api_client.sso(account: account)
        end
      end

      context "when the account already has a learn_worlds_user_id" do
        let(:learn_worlds_user_id_on_account) { 12345 }

        it "does not update the account with learn_worlds_user_id" do
          expect(account).not_to receive(:update_attribute)

          learn_worlds_api_client.sso(account: account)
        end
      end
    end

    context "when the LearnWorlds SSO response is not successful" do
      let(:mock_learn_worlds_sso_response) do
        double("mock_learn_worlds_sso_response",
          body: {
            success: false,
            errors: ["some LearnWorlds error message"],
          }.to_json
        )
      end

      it "logs an error" do
        expect(logger).to receive(:error).with("[LEARNWORLDS] Error performing SSO for account 1 - some LearnWorlds error message")

        learn_worlds_api_client.sso(account: account)
      end

      it "sends an error to Airbrake" do
        expect(error_notifier).to receive(:notify).with("[LEARNWORLDS] Error performing SSO for account 1 - some LearnWorlds error message")

        learn_worlds_api_client.sso(account: account)
      end

      it "refreshes the access token" do
        expect(authentication_service).to receive(:refresh_access_token)

        learn_worlds_api_client.sso(account: account)
      end

      it "returns an unsuccessful result" do
        result = learn_worlds_api_client.sso(account: account)

        expect(result.success?).to eq(false)
      end
    end
  end
end
