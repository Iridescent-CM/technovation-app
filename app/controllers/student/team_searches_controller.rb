module Student
  class TeamSearchesController < StudentController
    include RequireParentalConsentSigned
    include RequireLocationIsSet

    def new
      unless current_student.valid_coordinates?
        redirect_to student_location_details_path(return_to: request.fullpath),
          notice: "Please save your location so that you can search for nearby teams"
      end

      @search_filter = SearchFilter.new(search_params)
      @teams = SearchTeams.call(@search_filter).paginate(page: search_params[:page])
    end

    private

    def search_params
      params.permit(
        :utf8,
        :page,
        :nearby,
        :text,
        division_enums: []
      ).tap do |h|
        if h[:nearby].blank?
          params[:nearby] = h[:nearby] = current_account.address_details
        end

        if h[:division_enums].blank?
          params[:division_enums] = h[:division_enums] = Division.names.values
        end

        h[:country] = current_account.country
        h[:location] = current_account.address_details

        h[:scope] = current_scope
      end
    end
  end
end
