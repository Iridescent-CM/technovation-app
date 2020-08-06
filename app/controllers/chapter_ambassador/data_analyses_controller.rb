module ChapterAmbassador
  class DataAnalysesController < ChapterAmbassadorController
    def show
      data_analysis = DataAnalysis.for(current_ambassador, params.fetch(:id))
      render json: DataAnalysisSerializer.new(data_analysis).serialized_json
    end
  end
end
