class TeamsController < ApplicationController
  def show
    case params.fetch(:id)
    when /-\d{4}$/
      @team = Team.where("lower(name) = ?", params.fetch(:id).sub(/-\d{4}$/, '').gsub('-', ' ')).first
    else
      @team = Team.find(params.fetch(:id))
    end
  end
end
