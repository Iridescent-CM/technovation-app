require "rails_helper"

RSpec.describe CRM::SetupAccountForCurrentSeasonJob do
  let(:account) { instance_double(Account, id: 278) }
  let(:profile_type) { "student" }

  before do
    allow(Account).to receive(:find).with(account.id).and_return(account)
    allow(Salesforce::ApiClient).to receive(:new).and_return(salesforce_api_client)
  end

  let(:salesforce_api_client) { instance_double(Salesforce::ApiClient) }

  before do
    allow(salesforce_api_client).to receive(:setup_account_for_current_season)
  end

  it "creates a new Salesforce API client service" do
    expect(Salesforce::ApiClient).to receive(:new).with(
      account: account,
      profile_type: profile_type
    )

    CRM::SetupAccountForCurrentSeasonJob.perform_now(
      account_id: account.id,
      profile_type: profile_type
    )
  end

  it "calls the Salesforce API client service method that will update the account's program info" do
    expect(salesforce_api_client).to receive(:setup_account_for_current_season)

    CRM::SetupAccountForCurrentSeasonJob.perform_now(
      account_id: account.id,
      profile_type: profile_type
    )
  end
end
