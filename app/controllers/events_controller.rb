class EventsController < ApplicationController
  def index
  	# if current_user.can_judge?
  	# 	@team = nil
  	# 	@user = current_user
  	# end

   #  unless current_user.judge? ## is mentor, coach, or student
	  #   @team = current_user.current_team
	  #   authorize @team
	  # end

    @user = current_user
    @team = current_user.current_team

    unless @team.nil?
      authorize @team
    end

  end

  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.json{
        render json: @event
      }
    end
  end

  def valid_events
    conflict_region = params[:conflict_region].to_i
    events = {}
    if conflict_region < 0
      events = Event.open_for_signup().order("name!='Virtual Judging', name")
    else
      events = Event.open_for_signup.where("region != ? OR region IS NULL", conflict_region).order("name!='Virtual Judging', name")
    end
    render json: events
  end
end
