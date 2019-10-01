class SubscribeProfileToEmailList < ActiveJob::Base
  queue_as :default

  def perform(account_id, list_scope, options = {})
    account = Account.find(account_id)

    SubscribeEmailListJob.perform_now(
      account.email,
      list_scope,
      {
        NAME: account.full_name,
        FNAME: account.first_name,
        LNAME: account.last_name
      }
    )
  end
end
