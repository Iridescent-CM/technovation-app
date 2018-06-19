require "./app/models/certificate_recipient"
require "./app/technovation/override_certificate"

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

      account = minimum_score.judge_profile.account
      certificate_recipient = CertificateRecipient.new(account)

      logger.info "PRESERVE judge certificate - #{certificate_recipient.string_certificate_type} - Judge Account##{account.id}"

      OverrideCertificate.(account, certificate_recipient.certificate_type)

      logger.warn "DROP lowest score"
      submission.lowest_score_dropped!
      minimum_score.destroy
    end
  end
end