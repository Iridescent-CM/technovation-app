require "will_paginate/array"

module Admin
  class ScoresController < AdminController
    def index
      suspicious_scores = SuspiciousSubmissionScores.new

      respond_to do |format|
        format.html { }

        format.json {
          render json: SuspiciousScoreSerializer.new(suspicious_scores).serialized_json
        }
      end
    end

    def show
      @score = SubmissionScore.find(params.fetch(:id))
    end

    def destroy
      score = SubmissionScore.find(params.fetch(:id))
      score.destroy
      redirect_to admin_scores_path,
        success: "You deleted a score by #{score.judge_name}"
    end
  end
end
