module Student
  class JobStatusesController < StudentController
    def show
      render json: { status: Sidekiq::Status::status(params.fetch(:id)) }
    end
  end
end
