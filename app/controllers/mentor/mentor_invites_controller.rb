module Mentor
  class MentorInvitesController < MentorController
    def show
      @invite = current_mentor.mentor_invites.find_by(invite_token: params.fetch(:id)) ||
        NullInvite.new
    end

    def update
      if invite = current_mentor.mentor_invites.pending.find_by(invite_token: params.fetch(:id))
        invite.update_attributes(invite_params)
        redirect_based_on_status(invite)
      else
        redirect_to mentor_dashboard_path, alert: t("controllers.invites.update.failure")
      end
    end

    def destroy
      @invite = MentorInvite.find_by(team_id: current_mentor.team_ids,
                                     invite_token: params.fetch(:id))
      @invite.destroy
      redirect_back fallback_location: mentor_dashboard_path,
        success: t("controllers.invites.destroy.success", name: @invite.invitee_name)
    end

    private
    def redirect_based_on_status(invite)
      if invite.accepted?
        @path = mentor_team_path(invite.team)
        @msg = t("controllers.team_member_invites.update.success")
      else
        @path = mentor_dashboard_path
        @msg = t("controllers.team_member_invites.update.not_accepted")
      end

      redirect_to @path, success: @msg
    end

    def invite_params
      params.require(:team_member_invite).permit(:status)
    end

    class NullInvite
      def status
        "missing"
      end
    end
  end
end
