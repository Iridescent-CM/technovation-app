module Mentor
  class TeamMemberInvitesController < MentorController
    helper_method :account_type

    def create
      @team_member_invite = TeamMemberInvite.new(team_member_invite_params)

      if @team_member_invite.save
        redirect_to [:mentor, @team_member_invite.team],
          success: t("controllers.mentor.team_member_invites.create.success")
      else
        render :new
      end
    end

    private
    def team_member_invite_params
      params.require(:team_member_invite).permit(:invitee_email, :team_id).tap do |params|
        params[:inviter_id] = current_mentor.id
      end
    end

    def account_type
      "mentor"
    end
  end
end
