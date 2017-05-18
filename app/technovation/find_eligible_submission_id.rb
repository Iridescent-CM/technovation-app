module FindEligibleSubmissionId
  class << self
    def call(judge_profile, options = {})
      if quarterfinals? and options[:live] and judge_profile.selected_regional_pitch_event.live?
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
      judge.submission_scores.current_round.incomplete.last.try(:team_submission_id)
    end

    def random_eligible_id(judge)
      scored_submissions = judge.submission_scores.pluck(:team_submission_id)
      judge_conflicts = judge.team_region_division_names
      official_rpe_team_ids = if quarterfinals?
                                RegionalPitchEvent.official.joins(:teams).pluck(:team_id)
                              else
                                []
                              end
      candidates = TeamSubmission.current.public_send(rank_for_current_round)
        .where.not(
          id: scored_submissions
        )
        .includes(:team)
        .where.not(
          teams: { id: official_rpe_team_ids }
        )
        .where(
          "(complete_#{current_round}_official_submission_scores_count IS NULL OR
            complete_#{current_round}_official_submission_scores_count < 3) AND

              (pending_#{current_round}_official_submission_scores_count IS NULL OR
                pending_#{current_round}_official_submission_scores_count < 5)"
        )
        .select { |sub|
          (sub.complete? and
            not judge_conflicts.include?(sub.team.region_division_name))
        }
        .sort { |a, b|
          x = a.public_send("pending_#{current_round}_official_submission_scores_count") || 0
          y = b.public_send("pending_#{current_round}_official_submission_scores_count") || 0
          x <=> y
        }
        .sort { |a, b|
          x = a.public_send("complete_#{current_round}_official_submission_scores_count") || 0
          y = b.public_send("complete_#{current_round}_official_submission_scores_count") || 0
          x <=> y
        }
      sub = candidates.first
      sub && sub.id
    end

    def current_round
      case ENV.fetch("JUDGING_ROUND") { "QF" }
      when "QF"
        :quarterfinals
      when "SF"
        :semifinals
      end
    end

    def rank_for_current_round
      case current_round
      when :quarterfinals
        :quarterfinalist
      when :semifinals
        :semifinalist
      end
    end

    def quarterfinals?
      current_round == :quarterfinals
    end
  end
end
