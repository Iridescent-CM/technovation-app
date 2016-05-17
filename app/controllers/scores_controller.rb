class ScoresController < ApplicationController
  before_action :authenticate_user!

  def index
    @scores = VisibleScores.new(current_user.teams)
  end
end
