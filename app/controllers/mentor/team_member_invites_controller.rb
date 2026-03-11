module Mentor
  class TeamMemberInvitesController < MentorController
    include TeamMemberInviteController

    def update
      if SeasonToggles.judging_enabled_or_between?
        redirect_to mentor_dashboard_path,
          alert: t("views.team_member_invites.show.invites_disabled_by_judging")
      elsif invite = current_mentor.mentor_invites.pending.find_by(
        invite_token: params.fetch(:id)
      )

        if invite.update(invite_params)
          redirect_based_on_status(invite)
        end

      else
        redirect_to mentor_dashboard_path,
          alert: t("controllers.invites.update.failure")
      end
    end

    def decline
      @invite = current_mentor.mentor_invites.pending.find_by(invite_token: params[:id])
    end

    private

    def redirect_based_on_status(invite)
      if invite.accepted?
        @path = mentor_team_path(invite.team)
        @msg = t("controllers.team_member_invites.update.success")
      else
        MentorInviteDeclined.call(invite)
        @path = mentor_pending_team_requests_path
        @msg = t("controllers.team_member_invites.update.not_accepted")
      end

      redirect_to @path, success: @msg
    end

    def invite_params
      params.require(:team_member_invite).permit(:status, :decline_reason)
    end

    def current_profile
      current_mentor
    end
  end
end
