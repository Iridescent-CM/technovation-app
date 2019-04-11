module RegionalAmbassador
  class PrintableScoresController < RegionalAmbassadorController
    layout "printable_scores"

    def show
      @event = RegionalPitchEvent.includes(
        judges: :submission_scores,
        team_submissions: :submission_scores
      ).find(params[:id])

      judges = @event.judges
      teams = @event.teams.to_a
      judge_ids = judges.map { |judge| judge.id }

      @scores = @event.team_submissions
                .flat_map(&:scores)
                .reject { |score| !judge_ids.include?(score.judge_profile_id) }

      if judges.any? { |j| j.assigned_teams_for_event(@event).any? }
        @groups = []

        judges.each.with_index do |judge, idx|
          assigned_teams_for_event = judge.assigned_teams_for_event(@event).to_a

          if assigned_teams_for_event.any?
            index = @groups.find_index { |group| group.teams == assigned_teams_for_event }

            if index.nil?
              @groups.push({ judges: [judge], teams: assigned_teams_for_event })
            else
              @groups[index].judges.push(judge)
            end
          else
            index = @groups.find_index { |group| group.teams == teams }

            if index.nil?
              @groups.push({ judges: [judge], teams: teams })
            else
              @groups[index].judges.push(judge)
            end
          end
        end
      else
        @groups = [{ judges: judges, teams: teams }]
      end
    end
  end
end
