module AcceptTeamMemberInvite
  def self.call(invite, context)
    invite.accept!

    if account = Account.find_by(email: invite.invitee_email)
      invite.team.add_member(account)
      SignIn.(account, context,
              message: I18n.translate("controllers.team_member_invite_acceptances.show.success"),
              redirect_to: context.team_path(invite.team))
    else
      context.redirect_to context.student_signup_path(email: invite.invitee_email)
    end
  end
end
