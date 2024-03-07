class SyncBackgroundChecksJob < ActiveJob::Base
  queue_as :default

  def perform(admin_profile_id)
    accounts = Account.current.joins(:background_check).where.not(background_checks: {status: :clear})

    accounts.find_each do |account|
      SyncBackgroundCheck.new(account: account).call
    end
  end
end
