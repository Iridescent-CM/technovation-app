module ClearBackgroundCheck
  def self.call(background_check)
    background_check.clear!

    AccountMailer.background_check_clear(background_check.account).deliver_later

    if background_check.account.mentor_profile.present?
      account.mentor_profile.enable_searchability
    end
  end
end
