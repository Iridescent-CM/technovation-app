class Judges::ScoresController < ApplicationController
  def index
    @scores = Score.all
  end

  def new
    @score = Score.new
    categories
  end

  def create
    @score = Score.new(score_params)

    if @score.save
      redirect_to judges_scores_path, success: t("controllers.judges.scores.create.success")
    else
      render :new
    end
  end

  def edit
    score
    categories
    render :new
  end

  def update
    if score.update_attributes(score_params)
      redirect_to judges_scores_path, success: t("controllers.judges.scores.update.success")
    else
      render :new
    end
  end

  private
  def score_params
    begin
      params.require(:score).permit(:score_value_ids).tap do |list|
        list[:score_value_ids] = params.fetch(:score).fetch(:score_value_ids).values.flatten
      end
    rescue ActionController::ParameterMissing
      { }
    end
  end

  def categories
    @categories ||= ScoreCategory.all
  end

  def score
    @score ||= Score.find(params[:id])
  end
end
