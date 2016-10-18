module Student
  class TeamSearchesController < StudentController
    def new
      params[:nearby] = current_student.address_details if params[:nearby].blank?

      @search_filter = SearchFilter.new({
        nearby: params.fetch(:nearby),
        user: current_student,
        spot_available: true,
        text: params[:text],
      })

      @teams = SearchTeams.(@search_filter).paginate(page: params[:page])
    end
  end
end
