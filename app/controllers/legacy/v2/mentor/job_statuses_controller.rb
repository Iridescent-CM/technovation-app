module Legacy
  module V2
    module Mentor
      class JobStatusesController < MentorController
        def show
          job = Job.find_by(job_id: params.fetch(:id))
          render json: { status: job.status }
        end
      end
    end
  end
end
