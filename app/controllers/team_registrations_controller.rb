class TeamRegistrationsController < ApplicationController
  layout 'v3/application'

  def create
    team = TeamCreating.new(team_params)

    if team.save
      render json: team.as_json
    else
      render json: { errors: team.errors }
    end
  end

  private
  def team_params
    params.require(:team).permit(:name)
  end
end
