class Judges::ScoresController < ApplicationController
  def index
    @scores = Score.all
  end

  def new
    @score = Score.new
  end

  def create
    @score = Score.new(params.fetch(:score))

    if @score.save
      redirect_to judges_scores_path, notice: t("controllers.judges.scores.create.success")
    else
      render :new
    end
  end
end
