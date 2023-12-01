class UpdateAccountOnEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, currently_subscribed_as:)
    account = Account.find(account_id)

    Mailchimp::MailingList.new.update(account: account, currently_subscribed_as: currently_subscribed_as)
    Salesforce::ApiClient.new.update_contact(account: account)
  end
end
