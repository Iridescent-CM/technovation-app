class TeamsController < ApplicationController
  def show
    case params.fetch(:id)
    when /-\d{4}$/
      @team = Team.find_by!(friendly_id: params.fetch(:id))
    else
      @team = Team.find(params.fetch(:id))
    end
  end
end
