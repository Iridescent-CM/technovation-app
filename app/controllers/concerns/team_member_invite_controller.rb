module TeamMemberInviteController
  extend ActiveSupport::Concern

  included do
    helper_method :account_type
  end

  def show
    @invite = TeamMemberInvite.find_by(invite_token: params.fetch(:id))
  end

  def create
    @team_member_invite = TeamMemberInvite.new(team_member_invite_params)

    if @team_member_invite.save
      redirect_to [account_type, @team_member_invite.team],
        success: t("controllers.#{account_type}.team_member_invites.create.success")
    else
      render :new
    end
  end

  private
  def team_member_invite_params
    params.require(:team_member_invite).permit(:invitee_email, :team_id).tap do |params|
      params[:inviter_id] = current_account.id
    end
  end

  def account_type
    "application"
  end
end
