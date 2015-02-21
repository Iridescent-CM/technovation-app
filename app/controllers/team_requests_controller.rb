class TeamRequestsController < ApplicationController
  before_action :find_and_authorize_request

  def destroy
    @team_request.destroy
    if params.has_key? :home
      redirect_to '/'
    else
      redirect_to :back
    end
  end

  def approve
    @team_request.approved = true
    @team_request.save!

    if @team_request.user_request
      InviteMailer.invite_accepted_email(@team_request.user, @team_request.team).deliver
    end

    redirect_to :back
  end

  private
  def find_and_authorize_request
    @team_request = TeamRequest.find(params[:id])
    authorize @team_request
  end
end
