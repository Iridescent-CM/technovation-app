module ClearBackgroundCheck
  def self.call(background_check)
    background_check.clear!

    account = background_check.account

    AccountMailer.background_check_clear(account).deliver_later

    if account.mentor_profile.present?
      account.mentor_profile.enable_searchability
    end
  end
end
