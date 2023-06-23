module Admin
  class TeamMemberInvitesController < AdminController
    def destroy
      invite = TeamMemberInvite.find_by(invite_token: params.fetch(:id))

      if invite.destroy
        redirect_to(
          admin_team_path(invite.team),
          success: t("controllers.invites.destroy.success", name: invite.invitee_name)
        )
      else
        redirect_to(
          admin_team_path(invite.team),
          notice: t("controllers.application.general_error")
        )
      end
    end
  end
end
