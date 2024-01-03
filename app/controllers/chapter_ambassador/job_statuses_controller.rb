module ChapterAmbassador
  class JobStatusesController < ChapterAmbassadorController
    def show
      job = Job.find_by(job_id: params.fetch(:id))

      if job.status == "complete"
        render json: {
          status: job.status,
          download_url: current_ambassador.exports.last.file_url
        }
      else
        render json: {status: job.status}
      end
    end
  end
end
