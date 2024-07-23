class SubscribeAccountToEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, profile_type:)
    account = Account.find(account_id)

    Salesforce::ApiClient.new.add_contact(account: account)
  end
end
