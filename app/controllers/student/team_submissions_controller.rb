module Student
  class TeamSubmissionsController < StudentController
    def new
      params[:step] = :affirm_integrity if params[:step].blank?
      @team_submission = current_team.team_submissions.build(step: params[:step])
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
      @team_photo_uploader = ImageUploader.new
      @team_photo_uploader.success_action_redirect = student_team_photo_upload_confirmation_url(back: request.fullpath)
    end

    def edit
      @team_submission = current_team.team_submissions.find(params.fetch(:id))
      @team_submission.step = params[:step]

      @screenshots_uploader = ImageUploader.new
      @screenshots_uploader.success_action_redirect = student_team_submission_screenshot_upload_confirmation_url(back: student_team_submission_path(@team_submission))
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
      params.require(:team_submission).permit(
        :app_description,
        :integrity_affirmed,
        :source_code_external_url
      ).tap do |tapped|
        tapped[:step] = params[:submission_step]
      end
    end
  end
end
