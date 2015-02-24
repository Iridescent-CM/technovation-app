class EventsController < ApplicationController
  def index
  	if current_user.judge?
  		@team = nil
  		@user = current_user
  	else
	    @team = current_user.current_team
	    authorize @team
	end
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
