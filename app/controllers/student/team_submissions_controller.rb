module Student
  class TeamSubmissionsController < StudentController
    def new
      @team_submission = current_team.team_submissions.build
    end

    def create
      @team_submission = current_team.team_submissions.build(team_submission_params)

      if @team_submission.save
        redirect_to [:student, @team_submission],
          success: t("controllers.team_submissions.create.success")
      else
        render :new
      end
    end

    def show
      @team_submission = current_team.team_submissions.find(params.fetch(:id))
    end

    def edit
      @team_submission = current_team.team_submissions.find(params.fetch(:id))
    end

    def update
      @team_submission = current_team.team_submissions.find(params.fetch(:id))

      if @team_submission.update_attributes(team_submission_params)
        redirect_to [:student, @team_submission],
          success: t("controllers.team_submissions.update.success")
      else
        render :new
      end
    end

    private
    def team_submission_params
      params.require(:team_submission).permit(:integrity_affirmed)
    end
  end
end
