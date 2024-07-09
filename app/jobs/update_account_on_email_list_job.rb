class UpdateAccountOnEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, currently_subscribed_as:)
    account = Account.find(account_id)

    Salesforce::ApiClient.new.update_contact(account: account)
  end
end
