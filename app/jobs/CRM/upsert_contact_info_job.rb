class Crm::UpsertContactInfoJob < ActiveJob::Base
  queue_as :default

  # test
  def perform(account_id:)
    account = Account.find(account_id)

    Salesforce::ApiClient.new.upsert_contact_info_for(account: account)
  end
end
