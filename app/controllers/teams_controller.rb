class TeamsController < ApplicationController
  def show
    @team = Team.find(params.fetch(:id))
  end
end
