require "./app/models/certificate_recipient"

module DropLowestScores
  def self.call(submission, logger_opt = nil)
    logger = Logger.new(logger_opt)

    logger.formatter = proc do |severity, datetime, progname, msg|
      "#{msg}\n"
    end

    logger.info "----------------------------------------"

    if submission.lowest_score_dropped?
      logger.info "SKIP already dropped score for Submission##{submission.id}"
      return false
    else
      minimum_score = submission.semifinals_complete_submission_scores.min_by(&:total)

      logger.info "FIND lowest complete semifinals score for Submission##{submission.id}"
      logger.info "Team ID##{submission.team_id}"
      logger.info "SF Average: #{submission.semifinals_average_score}"
      logger.info submission.semifinals_complete_submission_scores.map(&:total).sort

      logger.warn "DROP lowest score"
      logger.info minimum_score.total

      submission.lowest_score_dropped!
      minimum_score.destroy

      logger.info "Updated SF Average: #{submission.reload.semifinals_average_score}"
    end
  end
end