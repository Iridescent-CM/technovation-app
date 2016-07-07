class TeamMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.team_mailer.invite_member.subject
  #
  def invite_member(team_member_invite)
    @greeting = "Hi"
    mail to: team_member_invite.invitee_email,
         from: team_member_invite.inviter_email
  end
end
