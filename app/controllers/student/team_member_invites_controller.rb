module Student
  class TeamMemberInvitesController < StudentController
    include TeamMemberInviteController

    def update
      invite = current_student.team_member_invites.pending.find_by(invite_token: params.fetch(:id))

      if invite_params[:status] == "accepted" and invite.cannot_be_accepted?
        decline_invitation(invite)
      elsif invite.update_attributes(invite_params)
        redirect_based_on_status(invite)
      else
        redirect_to :back, alert: t("controllers.application.general_error")
      end
    end

    private
    def decline_invitation(invite)
      invite.declined!
      redirect_to student_dashboard_path, alert: t("controllers.team_member_invites.update.already_on_team")
    end

    def redirect_based_on_status(invite)
      if invite.accepted?
        @path = student_team_path(invite.team)
        @msg = t("controllers.team_member_invites.update.success")
      else
        @path = student_dashboard_path
        @msg = t("controllers.team_member_invites.update.not_accepted")
      end

      redirect_to @path, success: @msg
    end

    def invite_params
      params.require(:team_member_invite).permit(:status)
    end

    def account_type
      "student"
    end

    def current_profile
      current_student
    end
  end
end
