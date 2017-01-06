module FindEligibleSubmissionId
  def self.call(judge_profile)
    judge_profile.submission_scores.detect(&:incomplete?).try(:team_submission_id) ||
      TeamSubmission.pluck(:id).sample
  end
end
