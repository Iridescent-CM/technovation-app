module RegionalAmbassador
  class ScoresController < RegionalAmbassadorController
    def index
      @events = RegionalPitchEvent.in_region_of(current_ambassador)
        .includes(:teams, :divisions, :judges)

      @virtual_senior_teams = Team.for_ambassador(current_ambassador)
        .not_attending_live_event
        .includes(team_submissions: :submission_scores)
        .senior
        .order(:name)

      @virtual_junior_teams = Team.for_ambassador(current_ambassador)
        .not_attending_live_event
        .includes(team_submissions: :submission_scores)
        .junior
        .order(:name)
    end

    def show
      @team_submission = TeamSubmission.includes(
        team: :division,
        submission_scores: :judge_profile
      ).friendly.find(params[:id])

      @team = @team_submission.team

      @scores = @team_submission.submission_scores

      @judges = @scores.flat_map(&:judge_profile).sort_by(&:first_name)
    end
  end
end
