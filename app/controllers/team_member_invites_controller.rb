class TeamMemberInvitesController < ApplicationController
  include TeamMemberInviteController

  def update
    invite = TeamMemberInvite.find_by(invite_token: params.fetch(:id))
    if invite.update_attributes(invite_params)
      sign_in_existing_invitee(invite)
    else
      redirect_to :back, alert: t("controllers.application.general_error")
    end
  end

  private
  def sign_in_existing_invitee(invite)
    return false unless !!invite and !!invite.invitee

    if invite.accepted?
      @path = student_team_path(invite.team)
      @msg = t("controllers.team_member_invites.update.success")
    else
      @path = student_dashboard_path
      @msg = t("controllers.team_member_invites.update.not_accepted")
    end

    SignIn.(invite.invitee, self, message: @msg, redirect_to: @path)
  end

  def invite_params
    params.require(:team_member_invite).permit(:status).tap do |p|
      p[:invitee_id] == FindAccount.(cookies.fetch(:auth_token) { "" })
    end
  end
end
