class TeamMemberInvitesController < ApplicationController
  include TeamMemberInviteController

  def update
    invite = TeamMemberInvite.find_by(invite_token: params.fetch(:id))
    invite.update_attributes(invite_params)
    sign_in_existing_invitee(invite) or
      enable_student_signup_for_joining_invited_team(invite)
  end

  private
  def sign_in_existing_invitee(invite)
    return false unless !!invite and !!invite.invitee

    SignIn.(invite.invitee, self,
            message: t("controllers.team_member_invites.update.success"),
            redirect_to: student_team_path(invite.team))
  end

  def enable_student_signup_for_joining_invited_team(invite)
    cookies[:team_invite_token] = invite.invite_token
    redirect_to student_signup_path(email: invite.invitee_email)
  end

  def invite_params
    params.require(:team_member_invite).permit(:status).tap do |p|
      p[:invitee_id] == FindAccount.(cookies.fetch(:auth_token) { "" })
    end
  end
end
