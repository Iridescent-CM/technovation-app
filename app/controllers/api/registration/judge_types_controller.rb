module Api::Registration
  class JudgeTypesController < ActionController::API
    def index
      render json: JudgeType.all.order(:order)
    end
  end
end
