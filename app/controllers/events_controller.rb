class EventsController < ApplicationController
  def index
  	if current_user.can_judge?
  		@team = nil
  		@user = current_user
  	end

    unless current_user.judge? ## is mentor, coach, or student
	    @team = current_user.current_team
	    authorize @team
	  end
  end

  # def edit
  #   @team = current_user.current_team
  #   authorize @team
  # end

  # def new
  #   @team = current_user.current_team
  #   authorize @team
  # end
end
