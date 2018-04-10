module FindEligibleSubmissionId
  SCORE_COUNT_LIMIT = 3

  class << self
    def call(judge_profile, options = {})
      if SeasonToggles.quarterfinals? and judge_profile.live_event?

        submission_id_from_live_event(judge_profile.event, options) or
          id_for_finished_score(judge_profile, options) or
            id_for_score_in_progress(judge_profile, options)

      else

        id_for_finished_score(judge_profile, options) or
          id_for_score_in_progress(judge_profile) or
              random_eligible_id(judge_profile)

      end
    end

    private
    def submission_id_from_live_event(event, options)
      id = options[:team_submission_id]

      if [nil, "null", "undefined"].include?(id)
        false
      elsif event.team_submission_ids.include?(Integer(id))
        id
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def id_for_score_in_progress(judge, options = {})
      if id = options[:score_id]
        judge.submission_scores.current_round.incomplete.find_by(
          id: id
        ).try(:team_submission_id)
      else
        judge.submission_scores.current_round.incomplete.last.try(
          :team_submission_id
        )
      end
    end

    def id_for_finished_score(judge, opts)
      judge.submission_scores.current_round.complete.find_by(
        id: opts[:score_id]
      ).try(:team_submission_id)
    end

    def random_eligible_id(judge)
      scored_submissions = judge.submission_scores.pluck(
        :team_submission_id
      )

      judge_conflicts = judge.team_region_division_names

      official_rpe_team_ids = if SeasonToggles.quarterfinals?
                                RegionalPitchEvent.current.official
                                  .joins(:teams)
                                  .pluck(:team_id)
                              else
                                []
                              end

      candidates = TeamSubmission.current.complete.public_send(
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
          "complete_#{current_round}_official_submission_scores_count " +
          "IS NULL OR " +

          "complete_#{current_round}_official_submission_scores_count " +
           "< #{SCORE_COUNT_LIMIT}"
        )
        .select { |s| !judge_conflicts.include?(s.team.region_division_name) }
        .sort { |a, b|
          a_complete = a.public_send(
            "complete_#{current_round}_official_submission_scores_count"
          ) || 0

          b_complete = b.public_send(
            "complete_#{current_round}_official_submission_scores_count"
          ) || 0

          [weighted(a), a_complete] <=> [weighted(b), b_complete]
        }

      sub = candidates.first
      sub && sub.id
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
      else
        raise "Judging is not enabled"
      end
    end

    def rank_for_current_round
      current_round.to_s.sub(/s$/, 'ist')
    end
  end
end
