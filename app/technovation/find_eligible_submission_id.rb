module FindEligibleSubmissionId
  SCORE_COUNT_LIMIT = 3

  class << self
    def call(judge_profile, options = {})
      if SeasonToggles.quarterfinals? and
          options[:live] and
            judge_profile.selected_regional_pitch_event.live?
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
    def submission_id_from_live_event(event, id)
      if id.nil?
        event.team_submission_ids.sample
      elsif event.team_submission_ids.include?(Integer(id))
        id
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def id_for_score_in_progress(judge)
      judge.submission_scores.current_round.incomplete.last.try(
        :team_submission_id
      )
    end

    def random_eligible_id(judge)
      scored_submissions = judge.submission_scores.pluck(
        :team_submission_id
      )

      judge_conflicts = judge.team_region_division_names

      official_rpe_team_ids = if SeasonToggles.quarterfinals?
                                RegionalPitchEvent.official.joins(:teams)
                                  .pluck(:team_id)
                              else
                                []
                              end

      candidates = TeamSubmission.current.public_send(
          rank_for_current_round
        )
        .where.not(
          id: scored_submissions
        )
        .includes(:team)
        .where.not(
          teams: { id: official_rpe_team_ids }
        )
        .where(
          "complete_#{current_round}_official_submission_scores_count IS NULL OR
            complete_#{current_round}_official_submission_scores_count < #{SCORE_COUNT_LIMIT}"
        )
        .select { |sub|
          (sub.complete? and
            not judge_conflicts.include?(sub.team.region_division_name))
        }
        .sort { |a, b|
          a_complete = a.public_send("complete_#{current_round}_official_submission_scores_count") || 0
          b_complete = b.public_send("complete_#{current_round}_official_submission_scores_count") || 0
          [weighted(a), a_complete] <=> [weighted(b), b_complete]
        }

      sub = candidates.first

      sub and sub.id
    end

    def weighted(sub)
      pending = sub.public_send(
        "pending_#{current_round}_official_submission_scores_count"
      ) || 0

      complete = sub.public_send(
        "complete_#{current_round}_official_submission_scores_count"
      ) || 0

      pending + 2 * complete
    end

    def current_round
      case SeasonToggles.judging_round
      when "qf"
        :quarterfinals
      when "sf"
        :semifinals
      end
    end

    def rank_for_current_round
      current_round.to_s.sub(/s$/, 'ist')
    end
  end
end
