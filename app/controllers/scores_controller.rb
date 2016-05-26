class ScoresController < ApplicationController
  TeamWithScores = Struct.new(:team_name, :rubrics)

  before_action :authenticate_user!

  def index
    @scores = current_user.teams.current.flat_map do |team|
      visible = VisibleScores.new(team)
      meaningful = MeaningfulScores.new(visible, 5)
      TeamWithScores.new(team.name, meaningful)
    end
  end
end
