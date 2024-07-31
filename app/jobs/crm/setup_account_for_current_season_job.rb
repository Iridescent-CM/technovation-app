class CRM::SetupAccountForCurrentSeasonJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, profile_type:)
    account = Account.find(account_id)

    Salesforce::ApiClient
      .new(
        account: account,
        profile_type: profile_type
      )
      .setup_account_for_current_season
  end
end
