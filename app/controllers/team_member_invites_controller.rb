class TeamMemberInvitesController < ApplicationController
  def show
    @invite = TeamMemberInvite.find_by(invite_token: params.fetch(:id))
  end

  def update
    invite = TeamMemberInvite.accept!(params.fetch(:id))
    sign_in_existing_invitee(invite) or
      redirect_to student_signup_path(email: invite.invitee_email)
  end

  private
  def sign_in_existing_invitee(invite)
    return false unless !!invite and !!invite.invitee

    SignIn.(invite.invitee, self,
            message: t("controllers.team_member_invites.update.success"),
            redirect_to: student_team_path(invite.team))
  end
end
