module RegionalAmbassador
  class TeamSubmissionsController < RegionalAmbassadorController
    def index
      @team_submissions = RegionalAmbassador::SearchTeamSubmissions.(params, current_ambassador)
        .paginate(per_page: params[:per_page], page: params[:page])
    end

    def show
      @team_submission = TeamSubmission.find(params[:id])
    end
  end
end
