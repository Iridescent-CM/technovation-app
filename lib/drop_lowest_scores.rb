require "./app/models/certificate_recipient"
require "./app/technovation/override_certificate"

module DropLowestScores
  def self.call(submission, logger_opt = nil)
    logger = Logger.new(logger_opt)

    logger.formatter = proc do |severity, datetime, progname, msg|
      "#{msg}\n"
    end

    logger.info "----------------------------------------"

    logger.info "DROP lowest complete semifinals score for TeamSubmission##{submission.id}"

    minimum_score = submission.semifinals_complete_submission_scores.min_by(&:total)

    logger.info "PRESERVE judge's certificate"
    account = minimum_score.judge_profile.account
    certificate_recipient = CertificateRecipient.new(account)
    OverrideCertificate.(account, certificate_recipient.certificate_type)

    logger.warn "DROP lowest score"
    minimum_score.destroy
  end
end