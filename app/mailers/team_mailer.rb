class TeamMailer < ApplicationMailer
  def invite_member(team_member_invite)
    @url = team_member_invite_acceptance_url(team_member_invite)

    mail to: team_member_invite.invitee_email,
         from: team_member_invite.inviter_email
  end
end
