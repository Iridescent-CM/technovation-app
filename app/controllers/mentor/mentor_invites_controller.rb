module Mentor
  class MentorInvitesController < ApplicationController
    def show
      @invite = MentorInvite.find_by(invite_token: params.fetch(:id))
    end

    def update
      invite = MentorInvite.find_by(invite_token: params.fetch(:id))

      if invite_params[:status] == "accepted" and not invite.invitee.can_join_a_team?
        reject_invitation(invite)
      elsif invite.update_attributes(invite_params)
        redirect_based_on_status(invite)
      else
        redirect_to :back, alert: t("controllers.application.general_error")
      end
    end

    private
    def reject_invitation(invite)
      invite.rejected!
      redirect_to mentor_dashboard_path, alert: t("controllers.team_member_invites.update.already_on_team")
    end

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
      params.require(:team_member_invite).permit(:status).tap do |p|
        p[:invitee_id] == FindAccount.(cookies.fetch(:auth_token) { "" })
      end
    end
  end
end
