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
    query = Elasticsearch::DSL::Search.search do |s|
      s.query do |q|
        q.bool do |b|
          b.must_not do |mn|
            mn.terms region_division_name: {
              index: JudgeProfile.index_name,
              type: "judge",
              id: judge.id,
              path: "region_division_names"
            }
          end

          b.must do |m|
            m.term regional_pitch_event_id: {
              value: "virtual"
            }
          end
        end
      end

      s.from 0
      s.size 10_000
    end

    results = TeamSubmission.search(query).results
    results.flat_map { |r| r._source.id }.sample
  end
end
