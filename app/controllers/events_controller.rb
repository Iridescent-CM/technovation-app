class EventsController < ApplicationController
  before_action :authenticate_user!, except: :valid_events

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
        render json: @event.as_json.merge(:when_to_occur_formatted => @event.when_to_occur.strftime("%m/%d/%y"))
      }
    end
  end

  def valid_events
    conflict_region = params[:conflict_region].to_i
    events = Event.nonconflicting_events([conflict_region])
    render json: events
  end
end
