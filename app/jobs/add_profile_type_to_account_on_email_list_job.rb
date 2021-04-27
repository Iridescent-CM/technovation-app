class AddProfileTypeToAccountOnEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(account_id:, profile_type:)
    account = Account.find(account_id)

    Mailchimp::MailingList.new.add_profile_type_to_account(profile_type: profile_type, account: account)
  end
end
