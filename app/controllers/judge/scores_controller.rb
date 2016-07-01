module Judge
  class ScoresController < JudgeController
    def index
      @scores = current_judge.scores
      @submission = Submission.visible_to(current_judge).random
    end

    def new
      @score = submission.scores.build
      categories
    end

    def create
      @score = submission.scores.build(score_params)

      if @score.save
        redirect_to judge_scores_path, success: t("controllers.judge.scores.create.success")
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
        redirect_to judge_scores_path, success: t("controllers.judge.scores.update.success")
      else
        render :new
      end
    end

    private
    def categories
      @categories ||= ScoreCategory.visible_to(current_judge)
    end

    def score
      @score ||= submission.scores.find(params.fetch(:id))
    end

    def submission
      @submission ||= Submission.find(params.fetch(:submission_id))
    end

    def score_params
      begin
        params.require(:score).permit(
          :score_value_ids,
          scored_values_attributes: [:id, :score_value_id, :comment]
        ).tap do |list|
          list[:judge_profile_id] = current_judge.profile_id
        end
      rescue ActionController::ParameterMissing
        { }
      end
    end
  end
end
