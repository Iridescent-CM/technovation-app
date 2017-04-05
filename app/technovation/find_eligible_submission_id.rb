module FindEligibleSubmissionId
  def self.call(judge_profile, options = {})
    if judge_profile.selected_regional_pitch_event.live?
      submission_id_from_live_event(
        judge_profile.selected_regional_pitch_event,
        options[:team_submission_id]
      )
    else
      id_for_score_in_progress(judge_profile) or
        random_eligible_id(judge_profile)
    end
  end

  private
  def self.submission_id_from_live_event(event, id)
    if id.nil?
      event.team_submission_ids.sample
    elsif event.team_submission_ids.include?(Integer(id))
      id
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def self.id_for_score_in_progress(judge)
    judge.submission_scores.incomplete.last.try(:team_submission_id)
  end

  def self.random_eligible_id(judge)
    # TODO: Add real logic here from elasticsearch work
    TeamSubmission.pluck(:id).sample
  end
end
