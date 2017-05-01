module Admin
  class ScoresController < AdminController
    def index
      params[:event] ||= "virtual"

      @event = RegionalPitchEvent.find(params[:event])
      events = RegionalPitchEvent
        .eager_load(:divisions, :judges, teams: { team_submissions: :submission_scores })

      @virtual_event = Team::VirtualRegionalPitchEvent.new
      @events = [@virtual_event] + events
    end

    def show
      @team_submission = TeamSubmission.includes(
        team: :division,
        submission_scores: { judge_profile: :account }
      ).friendly.find(params[:id])

      @team = @team_submission.team

      @event = @team.selected_regional_pitch_event

      @scores = @team_submission.submission_scores
        .complete
        .includes(judge_profile: :account)
        .references(:accounts)
        .order("accounts.first_name")

      render "regional_ambassador/scores/show"
    end
  end
end