class TeamsController < ApplicationController
  def show
    @team = Team.find(params.fetch(:id))
    render 'student/teams/show'
  end
end
