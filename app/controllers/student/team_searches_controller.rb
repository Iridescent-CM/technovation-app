module Student
  class TeamSearchesController < StudentController
    def new
      @search_filter = SearchFilter.new(search_params)
      @teams = SearchTeams.(@search_filter).paginate(page: search_params[:page])
    end

    private
    def search_params
      params.permit(
        :utf8,
        :page,
        :nearby,
        :text,
        division_enums: [],
      ).tap do |h|
        if h[:nearby].blank?
          params[:nearby] = h[:nearby] = current_account.address_details
        end

        if h[:division_enums].blank?
          params[:division_enums] = h[:division_enums] = Division.names.values
        end

        h[:country] = current_account.country
        h[:location] = current_account.address_details
      end
    end
  end
end
