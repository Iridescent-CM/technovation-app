class ScoresController < ApplicationController
  before_action :authenticate_user!

  def index
    visible_scores = VisibleScores.new(current_user.teams.current)

    @scores = visible_scores.map do |score|
      rubrics = MeaningfulScores.new(score.rubrics, 5)
      VisibleScores::TeamScore.new(score.team, rubrics)
    end
  end
end
