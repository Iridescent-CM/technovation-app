class EventsController < ApplicationController
  def index
    @team = current_user.current_team
    authorize @team
  end

  def edit
    @team = current_user.current_team
    authorize @team
  end

  def new
    @team = current_user.current_team
    authorize @team
  end
end
