class RecordLoginTimeJob < ActiveJob::Base
  queue_as :default

  def perform(account_id, epoch)
    account = Account.find(account_id)
    time = Time.at(epoch)
    account.update(last_logged_in_at: time)
  end
end
