module Mentor
  class ImageProcessJobsController < MentorController
    def create
      job = ProcessScreenshotsJob.perform_later(current_team.submission, params.fetch(:keys))
      render json: { status_url: mentor_job_status_url(job.job_id) }
    end
  end
end
