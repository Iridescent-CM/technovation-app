module RegionalAmbassador
  class PrintableScoresController < RegionalAmbassadorController
    layout "printable_scores"

    def show
      @event = RegionalPitchEvent.includes(
        judges: :submission_scores,
        team_submissions: :submission_scores
      ).find(params[:id])

      judges = @event.judges
      judge_ids = judges.map { |judge| judge.id }

      scores = @event.team_submissions
                .flat_map(&:scores)
                .reject { |score| !judge_ids.include?(score.judge_profile_id) }

      if judges.any? { |j| j.assigned_teams_for_event(@event).any? }
        @groups = {}
        included = []

        judges.each.with_index do |judge, idx|
          next if included.include?(judge.id)

          others_with_same_teams = judges.select do |j|
            j.id != judge.id && j.assigned_teams_for_event(@event) == judge.assigned_teams_for_event(@event)
          end

          event_submission_ids = @event.team_submissions.flat_map(&:id)
          @groups[idx] = judge.submission_scores.where(team_submission_id: event_submission_ids)
          @groups[idx] += others_with_same_teams.flat_map { |j|
            j.submission_scores.where(team_submission_id: event_submission_ids)
          }

          included << judge.id
          included += others_with_same_teams.map(&:id)
        end
      else
        @groups = { 0 => scores.sort_by(&:judge_name) }
      end

      @groups = @groups.reject { |i, s| s.empty? }
    end
  end
end
