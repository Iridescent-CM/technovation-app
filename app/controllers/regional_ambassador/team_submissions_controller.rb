module RegionalAmbassador
  class TeamSubmissionsController < RegionalAmbassadorController
    def index
      @team_submissions = RegionalAmbassador::SearchTeamSubmissions.(params, current_ambassador)
        .paginate(per_page: params[:per_page], page: params[:page])
    end

    def show
      @team_submission = TeamSubmission.friendly.find(params[:id])
      @team_submission.build_technical_checklist if @team_submission.technical_checklist.blank?
    end
  end
end
