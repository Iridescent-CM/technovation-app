class TeamMemberInviteAcceptancesController < ApplicationController
  def show
    invite = TeamMemberInvite.find_with_token(params.fetch(:id))
    invite.accept!

    if account = Account.find_by(email: invite.invitee_email)
      SignIn.(account, self,
              message: t("controllers.team_member_invite_acceptances.show.success"),
              redirect_to: team_path(invite.team))
    else
      redirect_to student_signup_path(email: invite.invitee_email)
    end
  end
end
