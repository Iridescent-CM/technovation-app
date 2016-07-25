module Student
  class TeamSearchesController < StudentController
    def new
      @search_filter = SearchFilter.new({
        nearby: current_student.address_details,
      })
      @teams = SearchTeams.(@search_filter)
    end
  end
end
