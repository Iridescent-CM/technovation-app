module RegionalAmbassador
  class PrintableScoresController < RegionalAmbassadorController
    layout "printable_scores"

    def show
      @event = RegionalPitchEvent.includes(team_submissions: :submission_scores).find(params[:id])
      @scores = @event.team_submissions.flat_map(&:submission_scores).sort_by(&:judge_name)
    end
  end
end
