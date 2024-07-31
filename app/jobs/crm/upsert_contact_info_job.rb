class CRM::UpsertContactInfoJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:)
    account = Account.find(account_id)

    Salesforce::ApiClient
      .new(account: account)
      .upsert_contact_info
  end
end
