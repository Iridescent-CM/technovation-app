module Student
  class TeamSubmissionFileUploadConfirmationsController < StudentController
    def show
      case params.fetch(:file_attribute)
      when "business_plan"
        ProcessBusinessPlanJob.perform_later(current_team.submission,
                                             params.fetch(:key))
      else
        ProcessUploadJob.perform_later(current_team.submission,
                                      params.fetch(:file_attribute),
                                      params.fetch(:key))
      end
      flash.now[:success] = t("controllers.teams.show.file_processing")
      @unprocessed_file_url = "//s3.amazonaws.com/#{params[:bucket]}/#{params[:key]}"
    end
  end
end
