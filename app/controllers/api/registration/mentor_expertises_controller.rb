module Api::Registration
  class MentorExpertisesController < ActionController::API
    def index
      render json: Expertise.all.order(:order)
    end
  end
end
