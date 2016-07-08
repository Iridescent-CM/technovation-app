module Mentor
  class TeamsController < MentorController
    def index
      @teams = current_mentor.teams
    end

    def show
      @team = current_mentor.teams.find(params.fetch(:id))
      render 'student/teams/show'
    end
  end
end
