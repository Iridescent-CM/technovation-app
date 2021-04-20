module FindEligibleSubmissionId
  SCORE_COUNT_LIMIT = 9

  class << self
    def call(judge_profile, options = {})
      if SeasonToggles.quarterfinals? && judge_profile.live_event?

        submission_id_from_live_event(judge_profile.events, options) ||
          id_for_finished_score(judge_profile, options) ||
          id_for_score_in_progress(judge_profile, options)

      else

        id_for_finished_score(judge_profile, options) ||
          id_for_score_in_progress(judge_profile, options) ||
          random_eligible_id(judge_profile)

      end
    end

    private

    def submission_id_from_live_event(events, options)
      id = options[:team_submission_id]

      if [nil, "null", "undefined"].include?(id)
        false
      elsif events.flat_map(&:team_submission_ids).include?(Integer(id))
        id
      else
        raise ActiveRecord::RecordNotFound
      end
    end

    def id_for_score_in_progress(judge, options = {})
      if (id = options[:score_id])
        judge.submission_scores.current_round.incomplete.not_recused.find_by(
          id: id
        ).try(:team_submission_id)
      else
        judge.submission_scores.current_round.incomplete.not_recused.first.try(
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
      round = current_round

      already_assigned_submission_ids = judge.submission_scores.pluck(
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
          id: already_assigned_submission_ids
        )
        .includes(:team)
        .where.not(
          teams: {id: official_rpe_team_ids}
        )
        .where(
          "complete_#{round}_official_submission_scores_count " \
          "IS NULL OR " \
          "complete_#{round}_official_submission_scores_count " \
           "< #{SCORE_COUNT_LIMIT}"
        )
        .sort { |a, b|
          a_complete = a.public_send(
            "complete_#{round}_official_submission_scores_count"
          ) || 0

          b_complete = b.public_send(
            "complete_#{round}_official_submission_scores_count"
          ) || 0

          [weighted(a, round), a_complete] <=> [weighted(b, round), b_complete]
        }

      sub = candidates.find { |s| !judge_conflicts.include?(s.team.region_division_name) }
      sub&.id
    end

    def weighted(sub, round)
      pending = sub.public_send(
        "pending_#{round}_official_submission_scores_count"
      ) || 0

      complete = sub.public_send(
        "complete_#{round}_official_submission_scores_count"
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
      current_round.to_s.sub(/s$/, "ist")
    end
  end
end
