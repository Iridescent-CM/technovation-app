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

end
