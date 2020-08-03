module ChapterAmbassador
  class PrintableScoresController < ChapterAmbassadorController
    layout "printable_scores"

    def show
      @event = RegionalPitchEvent.includes(
        judges: :submission_scores,
        team_submissions: :submission_scores
      ).find(params[:id])

      judges = @event.judges

      judge_ids = judges.map { |judge| judge.id }
      @scores = @event.team_submissions
                .flat_map(&:scores)
                .reject { |score| !judge_ids.include?(score.judge_profile_id) }

      @groups = []
      judges.each.with_index do |judge, idx|
        if judge.assigned_teams_for_event(@event).any?
          teams = judge.assigned_teams_for_event(@event).to_a
        else
          teams = @event.teams.to_a
        end

        if index = @groups.find_index { |group| group[:teams] == teams }
          @groups[index][:judges].push(judge)
        else
          @groups.push({ judges: [judge], teams: teams })
        end
      end
    end
  end
end
