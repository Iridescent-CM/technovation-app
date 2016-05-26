class ScoresController < ApplicationController
  before_action :authenticate_user!

  def index
    @scores = VisibleScores.new(current_user.teams.current,
                                filter_with: MeaningfulScores,
                                filter_limit: 5)
  end
end
