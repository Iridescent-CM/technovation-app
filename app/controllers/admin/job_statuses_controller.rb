module Admin
  class JobStatusesController < AdminController
    def show
      job = Job.find_by(job_id: params.fetch(:id))

      if job.status == "complete"
        render json: {
          status: job.status,
          download_url: current_admin.exports.last.file_url,
        }
      else
        render json: { status: job.status }
      end
    end
  end
end
