class ScoresController < ApplicationController
  TeamScore = Struct.new(:team, :rubrics)

  before_action :authenticate_user!

  def index
    @scores = current_user.teams.map do |team|
      visible_stages = Setting.scoresVisible.map do |s|
        Rubric.stages[s]
      end

      if visible_stages.any?
        rubrics = team.rubrics.where(stage: visible_stages)
        TeamScore.new(team.name, rubrics)
      else
        TeamScore.new(team.name, [])
      end
    end
  end
end
