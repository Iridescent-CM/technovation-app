module Student
  class MentorInvitesController < StudentController
    def create
      @mentor_invite = MentorInvite.new(mentor_invite_params)

      if @mentor_invite.save
        redirect_to [:student, @mentor_invite.team],
          success: t("controllers.student.team_member_invites.create.success")
      else
        render :new
      end
    end

    private
    def mentor_invite_params
      params.require(:mentor_invite).permit(:invitee_email).tap do |params|
        params[:inviter_id] = current_student.id
        params[:team_id] = current_student.team_id
      end
    end
  end
end
