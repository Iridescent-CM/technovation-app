class SubscribeAccountToEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, profile_type:)
    account = Account.find(account_id)

    Mailchimp::MailingList.new.subscribe(account: account, profile_type: profile_type)
    Salesforce::ApiClient.new.add_contact(account: account)
  end
end
