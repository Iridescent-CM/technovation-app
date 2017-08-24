module Student
  class TeamMemberInvitesController < StudentController
    include TeamMemberInviteController

    def update
      invite = current_student.team_member_invites.pending.find_by(
        invite_token: params.fetch(:id)
      )

      decline_invites_that_cannot_be_accepted(invite) or
        apply_chosen_status_to_existing_invite(invite) or
          redirect_existing_invite_by_status or
            redirect_back fallback_location: student_dashboard_path,
              alert: t("controllers.application.general_error")
    end

    private
    def decline_invites_that_cannot_be_accepted(invite)
      if invite.present? and
          invite_params[:status] == "accepted" and
            invite.cannot_be_accepted?
        invite.declined!
        redirect_to student_dashboard_path,
          alert: t("controllers.team_member_invites.update.already_on_team")
      end
    end

    def apply_chosen_status_to_existing_invite(invite)
      if invite.present? and invite.update_attributes(invite_params)
        if invite.accepted?
          TeamRosterManaging.add(invite.team, current_student)
        end

        redirect_based_on_status(invite)
      end
    end

    def redirect_existing_invite_by_status
      if invite = current_student.team_member_invites.find_by(
                    invite_token: params.fetch(:id)
                  )
        redirect_based_on_status(invite)
      end
    end

    def redirect_based_on_status(invite)
      if invite.accepted?
        if current_student.full_access_enabled?
          @path = student_team_path(invite.team)
        else
          @path = student_dashboard_path
        end

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

    def current_profile
      current_student
    end
  end
end
