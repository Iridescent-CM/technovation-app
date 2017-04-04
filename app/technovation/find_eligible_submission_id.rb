module FindEligibleSubmissionId
  def self.call(judge_profile, options = {})
    if options[:submission_score_id]
      judge_profile.submission_scores
        .find(options[:submission_score_id])
        .team_submission_id
    elsif judge_profile.selected_regional_pitch_event.live?
      if options[:team_submission_id]
        judge_profile.selected_regional_pitch_event
          .team_submissions
          .find(options[:team_submission_id])
          .id
      else
        judge_profile.selected_regional_pitch_event
          .team_submissions
          .pluck(:id)
          .sample
      end
    else
      judge_profile.submission_scores
        .incomplete
        .last
        .try(:team_submission_id) || TeamSubmission.pluck(:id).sample
    end
  end
end
