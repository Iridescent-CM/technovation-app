class UpdateRegistrationInviteJob < ActiveJob::Base
  queue_as :default

  def perform(invite_code:, account_id:)
    registration_invite = UserInvitation.find_by(admin_permission_token: invite_code)
    account = Account.find(account_id)

    if registration_invite.present?
      registration_invite.update_column(:account_id, account.id)
      registration_invite.registered!

      if account.judge_profile.present?
        registration_invite.events.each do |event|
          event.user_invitations.destroy(registration_invite)
          event.judges << account.judge_profile
        end

        registration_invite.judge_assignments.each do |assignment|
          assignment.assigned_judge = account.judge_profile

          assignment.save!
        end
      end
    end
  end
end
