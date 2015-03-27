class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.friendly.find(params[:id])
    authorize @user
  end

  def edit
    @user = User.friendly.find(params[:id])
    authorize @user
  end

  def update
    @user = User.friendly.find(params[:id])
    authorize @user

    if @user.update(user_params)
      if params[:user][:event_signup]
        flash[:notice] = 'Event signup updated'
        redirect_to :back
      elsif params[:user][:judging] == '0'
        flash[:notice] = "You are no longer signed up to judge."        
        redirect_to :back
      elsif params[:user][:judging] == '1'
        flash[:notice] = "You are now a judge! Sign up for an event to judge."
        redirect_to events_path
      else
        flash[:notice] = 'Profile Updated!'
        redirect_to @user
      end
    else
      render :edit
    end
  end

  def invite
    @user = User.friendly.find(params[:id])
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

  def bg_check
  end

  private
  def user_params
    params.require(:user).permit(
      :about,
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

      :event_id,
      :judging,
      :conflict_region,
      :judging_region,
    )
  end

end
