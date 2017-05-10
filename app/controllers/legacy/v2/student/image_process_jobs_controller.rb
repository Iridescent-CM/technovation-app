module Legacy
  module V2
    module Student
      class ImageProcessJobsController < StudentController
        def create
          job = ProcessScreenshotsJob.perform_later(current_team.submission, params.fetch(:keys))
          render json: { status_url: student_job_status_url(job.job_id) }
        end
      end
    end
  end
end
