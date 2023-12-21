class TeamsController < ApplicationController
  def show
    @team = case params.fetch(:id)
    when /-\d{4}$/
      Team.find_by!(legacy_id: params.fetch(:id))
    else
      Team.find(params.fetch(:id))
    end
  end
end
