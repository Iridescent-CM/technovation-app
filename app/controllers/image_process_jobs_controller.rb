module Student
  class ImageProcessJobsController < StudentController
    job = ProcessScreenshotsJob.perform_later(current_team.submission, params.fetch(:keys))
    render json: { job_id: job.id }
  end
end
