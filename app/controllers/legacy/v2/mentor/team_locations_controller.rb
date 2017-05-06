module Legacy
  module V2
    module Mentor
      class TeamLocationsController < MentorController
        def edit
          @team = current_mentor.teams.find(params[:id])
          @team.city ||= current_mentor.city
          @team.state_province ||= current_mentor.state_province
          @team.country ||= current_mentor.country
        end
      end
    end
  end
end
