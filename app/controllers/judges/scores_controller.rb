class Judges::ScoresController < ApplicationController
  def index
    @scores = Score.all
  end

  def new
    @score = Score.new
    @categories = ScoreCategory.all
  end

  def create
    @score = Score.new(score_params)

    if @score.save
      redirect_to judges_scores_path, success: t("controllers.judges.scores.create.success")
    else
      render :new
    end
  end

  private
  def score_params
    params.require(:score).permit(:score_value_ids).tap do |list|
      list[:score_value_ids] = params.fetch(:score).fetch(:score_value_ids).values.flatten
    end
  end
end
