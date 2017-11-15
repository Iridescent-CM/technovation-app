class AttachUserInvitationJob < ActiveJob::Base
  queue_as :default

  def perform(account_id)
    account = Account.find(account_id)
    if invite = UserInvitation.find_by(email: account.email)
      invite.update_column(:account_id, account.id)
      invite.registered!
    end
  end
end
