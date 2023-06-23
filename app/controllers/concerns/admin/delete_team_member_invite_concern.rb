module Admin::DeleteTeamMemberInviteConcern
  extend ActiveSupport::Concern

  def destroy
    invite = TeamMemberInvite.find_by(invite_token: params.fetch(:id))

    if invite.destroy
      redirect_to(
        send("#{current_scope}_team_path", invite.team),
        success: t("controllers.invites.destroy.success", name: invite.invitee_name)
      )
    else
      redirect_to(
        send("#{current_scope}_team_path", invite.team),
        notice: t("controllers.application.general_error")
      )
    end
  end
end
