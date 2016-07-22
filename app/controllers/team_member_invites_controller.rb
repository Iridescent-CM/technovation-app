class TeamMemberInvitesController < ApplicationController
  def show
    @invite = TeamMemberInvite.find_by(invite_token: params.fetch(:id))
  end

  def update
    invite = TeamMemberInvite.accept!(params.fetch(:id))
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
end
