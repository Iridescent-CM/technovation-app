module Admin
  class TeamSubmissionsController < AdminController
    def index
      @team_submissions = TeamSubmission.all
        .paginate(per_page: params[:per_page], page: params[:page])
    end
  end
end
