class AttachUserInvitationJob < ActiveJob::Base
  queue_as :default

  def perform(account_id)
    account = Account.find(account_id)

    if invite = UserInvitation.find_by(email: account.email)
      invite.update_column(:account_id, account.id)
      invite.registered!

      if account.judge_profile.present?
        invite.events.each do |event|
          event.user_invitations.destroy(invite)
          event.judges << account.judge_profile
        end

        invite.judge_assignments.each do |assignment|
          assignment.assigned_judge = account.judge_profile
          assignment.save!
        end
      end
    end
  end
end
