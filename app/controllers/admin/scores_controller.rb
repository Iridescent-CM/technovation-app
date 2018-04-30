require "will_paginate/array"

module Admin
  class ScoresController < AdminController
    include DatagridController

    use_datagrid with: ScoresGrid

    def index
      suspicious_scores = SuspiciousSubmissionScores.new

      respond_to do |format|
        format.html {
          @scores_grid = ScoresGrid.new(grid_params) { |scope|
            scope.page(params[:page])
          }
        }

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

    private
    def grid_params
      grid = (params[:scores_grid] ||= {}).merge(
        admin: true,
        country: Array(params[:scores_grid][:country]),
        state_province: Array(params[:scores_grid][:state_province]),
      )

      grid.merge(
        column_names: detect_extra_columns(grid),
      )
    end
  end
end
