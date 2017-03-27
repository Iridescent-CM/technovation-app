module FindEligibleSubmissionId
  def self.call(judge_profile, options = {})
    if options[:submission_score_id]
      judge_profile.submission_scores
        .find(options[:submission_score_id])
        .team_submission_id
    else
      judge_profile.submission_scores
        .incomplete
        .last
        .try(:team_submission_id) || TeamSubmission.pluck(:id).sample
    end
  end
end
