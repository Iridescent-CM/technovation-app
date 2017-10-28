require 'uri'

module RegionalAmbassador
  class SavedSearchesController < RegionalAmbassadorController
    def show
      @saved_search = current_ambassador.saved_searches.find(params[:id])

      redirect_to regional_ambassador_participants_path(
        @saved_search.param_root => Rack::Utils.parse_nested_query(
          @saved_search.search_string
        )
      )
    end
    def create
      @saved_search = current_ambassador.saved_searches.build(saved_search_params)

      if @saved_search.save
        render json: @saved_search
      else
        render json: @saved_search.errors, status: :unprocessable_entity
      end
    end

    private
    def saved_search_params
      params.require(:saved_search).permit(:name, :param_root, :search_string)
    end
  end
end
