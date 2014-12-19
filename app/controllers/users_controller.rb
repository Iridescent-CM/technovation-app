class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update(user_params)
      redirect_to @user
    else
      redirect_to :back
    end
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


  private
  def user_params
    params.require(:user).permit(
      :avatar,
      :school,
      :grade,

      :home_city,
      :home_state,
      :home_country,
      :postal_code,

      :salutation,
      :science,
      :engineering,
      :project_management,
      :finance,
      :marketing,
      :design,
      :connect_with_other,
    )
  end

end
