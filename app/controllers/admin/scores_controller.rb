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
    end
  end
end
