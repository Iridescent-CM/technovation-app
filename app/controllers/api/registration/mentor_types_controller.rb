module Api::Registration
  class MentorTypesController < ActionController::API
    def index
      render json: MentorType.all.order(:order)
    end
  end
end
