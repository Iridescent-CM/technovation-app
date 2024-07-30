class CRM::SetupAccountForCurrentSeasonJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, profile_type:)
    account = Account.find(account_id)

    Salesforce::ApiClient.new.setup_account_for_current_season(
      account: account,
      profile_type: profile_type
    )
  end
end
