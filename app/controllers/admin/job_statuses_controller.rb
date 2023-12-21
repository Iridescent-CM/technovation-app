module Admin
  class JobStatusesController < AdminController
    def show
      job = Job.find_by(job_id: params.fetch(:id))
      render json: {status: job.status, payload: job.payload}
    end
  end
end
