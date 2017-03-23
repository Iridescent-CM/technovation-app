module RegionalAmbassador
  class TeamSubmissionsController < RegionalAmbassadorController
    def index
      params[:per_page] = 15 if params[:per_page].blank?
      params[:page] = 1 if params[:page].blank?

      @team_submissions = RegionalAmbassador::SearchTeamSubmissions.(params, current_ambassador)
        .uniq
        .page(params[:page].to_i)
        .per_page(params[:per_page].to_i)

      if @team_submissions.empty?
        @team_submissions = @team_submissions.page(1)
      end
    end

    def show
      @team_submission = TeamSubmission.friendly.find(params[:id])
      @team_submission.build_technical_checklist if @team_submission.technical_checklist.blank?
    end
  end
end
