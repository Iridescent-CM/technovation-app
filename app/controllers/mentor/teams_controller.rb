module Mentor
  class TeamsController < MentorController
    def show
      @team = current_mentor.teams.find(params.fetch(:id))
      render 'student/teams/show'
    end
  end
end
