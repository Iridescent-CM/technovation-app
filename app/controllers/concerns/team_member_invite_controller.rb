module TeamMemberInviteController
  extend ActiveSupport::Concern

  def show
    @invite = TeamMemberInvite.find_by(
      invite_token: params.fetch(:id)
    ) || NullInvite.new

    if @invite.invitee and @invite.invitee != current_profile
      signin = @invite.invitee.account
      SignIn.(signin, self, redirect_to: "#{current_scope}_team_member_invite_path")
    else
      render template: "team_member_invites/show_#{@invite.status}", layout: "public"
    end
  end

  def create
    @team_member_invite = TeamMemberInvite.new(team_member_invite_params)

    if @team_member_invite.save
      redirect_to [
        current_scope,
        @team_member_invite.team,
        { anchor: "students" }
      ],
      success: t("controllers.team_member_invites.create.success")
    else
      render :new
    end
  end

  def destroy
    if current_profile.team_ids.any?
      @invite = TeamMemberInvite.find_by(
        team_id: current_profile.team_ids,
        invite_token: params.fetch(:id)
      )

      if @invite
        @invite.destroy
        redirect_to [
          current_scope,
          @invite.team,
          { anchor: "students" }
        ],
        success: t("controllers.invites.destroy.success",
                   name: @invite.invitee_name)
      else
        redirect_to [current_scope, :dashboard],
          notice: t("controllers.invites.destroy.not_found")
      end
    else
      redirect_to [current_scope, :dashboard],
        notice: t("controllers.application.general_error")
    end
  end

  private
  def team_member_invite_params
    params.require(:team_member_invite).permit(
      :invitee_email,
      :team_id
    ).tap do |params|
      params[:inviter] = current_profile
    end
  end
end
