module Admin
  class DataAnalysesController < AdminController
    def show
      data_analysis = DataAnalysis.for(current_admin, params.fetch(:id))
      render json: DataAnalysisSerializer.new(data_analysis).serialized_json
    end
  end
end
