require "rails_helper"

RSpec.describe CRM::UpsertContactInfoJob do
  let(:account) { instance_double(Account, id: 2442) }
  let(:profile_type) { "student" }

  before do
    allow(Account).to receive(:find).with(account.id).and_return(account)
    allow(Salesforce::ApiClient).to receive(:new).and_return(salesforce_api_client)
  end

  let(:salesforce_api_client) { instance_double(Salesforce::ApiClient) }

  before do
    allow(salesforce_api_client).to receive(:upsert_contact_info)
  end

  it "creates a new instance of the Salesforce API client service" do
    expect(Salesforce::ApiClient).to receive(:new)
      .with(
        account: account,
        profile_type: profile_type
      )

    CRM::UpsertContactInfoJob.perform_now(
      account_id: account.id,
      profile_type: profile_type
    )
  end

  it "calls the Salesforce API client service method that will upsert the account's contact info" do
    expect(salesforce_api_client).to receive(:upsert_contact_info)

    CRM::UpsertContactInfoJob.perform_now(account_id: account.id)
  end
end
