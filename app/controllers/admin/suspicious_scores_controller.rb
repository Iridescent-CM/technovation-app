module Admin
  class SuspiciousScoresController < AdminController
    def index
      suspicious_scores = SuspiciousSubmissionScores.new
      render json: SuspiciousScoreSerializer.new(
        suspicious_scores,
        is_collection: true
      ).serialized_json
    end
  end
end
