module Student
  class TeamMemberInvitesController < StudentController
    helper_method :account_type

    def create
      @team_member_invite = TeamMemberInvite.new(team_member_invite_params)

      if @team_member_invite.save
        redirect_to [:student, @team_member_invite.team],
          success: t("controllers.student.team_member_invites.create.success")
      else
        render :new
      end
    end

    private
    def team_member_invite_params
      params.require(:team_member_invite).permit(:invitee_email).tap do |params|
        params[:inviter_id] = current_student.id
        params[:team_id] = current_student.team_id
      end
    end

    def account_type
      "student"
    end
  end
end
