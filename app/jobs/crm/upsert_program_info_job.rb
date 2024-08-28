class CRM::UpsertProgramInfoJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, profile_type:, season: Season.current.year)
    account = Account.find(account_id)

    Salesforce::ApiClient
      .new(
        account: account,
        profile_type: profile_type
      )
      .upsert_program_info(season: season)
  end
end
