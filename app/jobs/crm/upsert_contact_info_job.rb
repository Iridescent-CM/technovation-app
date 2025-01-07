class CRM::UpsertContactInfoJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, profile_type: nil)
    account = Account.find(account_id)

    Salesforce::ApiClient
      .new(
        account: account,
        profile_type: profile_type
      )
      .upsert_contact_info
  end
end
