class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def invite
    @user = User.find(params[:id])
    authorize @user

    @team = current_user.current_team
    @team.team_requests << TeamRequest.new(
      user: @user,
      team: @team,
      approved: false,
      user_request: false
    )
    if @team.save
      flash[:notice] = 'Team Request Sent'
    else
      flash[:alert] = 'An error occured during invite'
    end
    redirect_to @user
  end
end
