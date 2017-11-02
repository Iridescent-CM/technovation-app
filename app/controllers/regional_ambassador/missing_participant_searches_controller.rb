module RegionalAmbassador
  class MissingParticipantSearchesController < RegionalAmbassadorController
    helper_method :search_params

    def new
      @missing_participant_search = MissingParticipantSearch.new(
        params[:missing_participant_search]
      )
    end

    def show
      searched_params = {}

      search_params.each do |k, v|
        searched_params[k] = v unless v.blank?
      end

      @account = Account.find_by(searched_params)
    end

    def create
      @missing_participant_search = MissingParticipantSearch.new(search_params)

      redirect_to regional_ambassador_missing_participant_search_path(
        missing_participant_search: @missing_participant_search.attributes
      )
    end

    private
    def search_params
      params.require(:missing_participant_search).permit(
        :first_name,
        :last_name,
        :email,
      )
    end
  end
end
