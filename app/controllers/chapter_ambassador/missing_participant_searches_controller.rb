module ChapterAmbassador
  class MissingParticipantSearchesController < ChapterAmbassadorController
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
          where_clause = "lower(unaccent(replace(#{k}, '.', ''))) = "
          where_clause += "'#{v.downcase.strip.delete(".")}'"

          clauses.push(where_clause)
        end
      end

      if clauses.any?
        @account = Account.where(clauses.join(" AND ")).first
      end
    end

    def create
      @missing_participant_search = MissingParticipantSearch.new(
        search_params
      )

      redirect_to chapter_ambassador_missing_participant_search_path(
        missing_participant_search: @missing_participant_search.attributes
      )
    end

    private

    def search_params
      params.require(:missing_participant_search).permit(
        :first_name,
        :last_name,
        :email
      )
    end
  end
end
