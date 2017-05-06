module Legacy
  module V2
    module Student
      class JobStatusesController < StudentController
        def show
          job = Job.find_by(job_id: params.fetch(:id))
          render json: { status: job.status }
        end
      end
    end
  end
end
