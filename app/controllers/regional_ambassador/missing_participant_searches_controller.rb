module RegionalAmbassador
  class MissingParticipantSearchesController < RegionalAmbassadorController
    helper_method :search_params

    def new
      @missing_participant_search = MissingParticipantSearch.new(
        params[:missing_participant_search]
      )
    end

    def show
      clauses = []
      search_params.each do |k, v|
        unless v.blank?
          clauses.push("lower(unaccent(#{k})) = '#{v.downcase}'")
        end
      end

      @account = Account.where(clauses.join(" AND ")).first
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
