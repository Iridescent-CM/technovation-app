class SyncBackgroundCheck
  def initialize(account:)
    @account = account
  end

  def call
    background_check = @account.background_check

    if !background_check.invitation_completed?
      sync_invitation
    else
      sync_background_check
    end
  end

  private

  attr_reader :account

  def sync_invitation
    InvitationChecking.new(account).execute
  end

  def sync_background_check
    BackgroundChecking.new(account.background_check).execute
  end
end
