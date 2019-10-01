class UpdateProfileOnEmailListJob < ActiveJob::Base
  queue_as :default

  def perform(account_id, email_was, list_scope)
    account = Account.find(account_id)

    UpdateEmailListJob.perform_now(
      email_was,
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
