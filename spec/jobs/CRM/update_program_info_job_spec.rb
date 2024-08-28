require "rails_helper"

RSpec.describe CRM::UpsertProgramInfoJob do
  let(:account) { instance_double(Account, id: 9461) }
  let(:profile_type) { "student" }

  before do
    allow(Account).to receive(:find).with(account.id).and_return(account)
    allow(Salesforce::ApiClient).to receive(:new).and_return(salesforce_api_client)
  end

  let(:salesforce_api_client) { instance_double(Salesforce::ApiClient) }

  before do
    allow(salesforce_api_client).to receive(:upsert_program_info)
  end

  it "creates a new Salesforce API client service" do
    expect(Salesforce::ApiClient).to receive(:new).with(
      account: account,
      profile_type: profile_type
    )

    CRM::UpsertProgramInfoJob.perform_now(
      account_id: account.id,
      profile_type: "student"
    )
  end

  it "calls the Salesforce API client service method that will update the account's program info" do
    expect(salesforce_api_client).to receive(:upsert_program_info)

    CRM::UpsertProgramInfoJob.perform_now(
      account_id: account.id,
      profile_type: "student"
    )
  end

  context "when a season is provided" do
    let(:season) { Season.new(2020).year }

    it "calls the Salesforce API client service and includes the provided year" do
      expect(salesforce_api_client).to receive(:upsert_program_info)
        .with(season: season)

      CRM::UpsertProgramInfoJob.perform_now(
        account_id: account.id,
        profile_type: "student",
        season: season
      )
    end
  end
end
