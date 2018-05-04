module Admin
  class SuspiciousScoresController < AdminController
    def index
      suspicious_scores = SuspiciousSubmissionScores.new
      render json: SuspiciousScoreSerializer.new(suspicious_scores).serialized_json
    end
  end
end