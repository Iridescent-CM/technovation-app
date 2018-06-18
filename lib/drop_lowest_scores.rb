module DropLowestScores
  MIN_SCORES_LIMIT = 5

  def self.call(submission, logger_opt = nil)
    logger = Logger.new(logger_opt)

    logger.formatter = proc do |severity, datetime, progname, msg|
      "#{msg}\n"
    end

    logger.info "----------------------------------------"

    logger.info "CONSIDER complete semifinals scores for TeamSubmission##{submission.id}"

    if submission.semifinals_complete_submission_scores.count >= MIN_SCORES_LIMIT
      logger.warn "DROP lowest score"

      minimum_score = submission.semifinals_complete_submission_scores.min_by(&:total)
      minimum_score.destroy
    else
      logger.info "SKIP"
    end
  end
end