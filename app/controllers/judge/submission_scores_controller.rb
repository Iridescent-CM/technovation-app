module Judge
  class SubmissionScoresController < JudgeController
    def new
      @submission_score = current_judge.submission_scores.build
    end
  end
end
