class TeamMailer < ApplicationMailer
  def invite_member(team_member_invite)
    @url = team_member_invite_acceptance_url(team_member_invite)

    mail to: team_member_invite.invitee_email,
         from: team_member_invite.inviter_email
  end

  def invite_mentor(mentor_invite)
    @url = mentor_invite_acceptance_url(mentor_invite)

    mail to: mentor_invite.invitee_email,
         from: mentor_invite.inviter_email,
         template_name: :invite_member
  end
end
