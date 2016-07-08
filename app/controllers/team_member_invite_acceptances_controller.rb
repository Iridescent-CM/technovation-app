class TeamMemberInviteAcceptancesController < ApplicationController
  def show
    invite = TeamMemberInvite.find_with_token(params.fetch(:id))
    invite.accept!
    sign_in_existing_invitee(invite) or
      redirect_to student_signup_path(email: invite.invitee_email)
  end

  private
  def sign_in_existing_invitee(invite)
    return false unless !!invite.invitee

    SignIn.(invite.invitee, self,
            message: t("controllers.team_member_invite_acceptances.show.success"),
            redirect_to: team_path(invite.team))
  end
end
