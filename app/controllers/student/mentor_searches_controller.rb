module Student
  class MentorSearchesController < StudentController
    def new
      @search_filter = SearchFilter.new(search_filter_params)
      @expertises = Expertise.all
      @mentors = SearchMentors.(@search_filter).paginate(page: params[:page])
    end

    private
    def search_filter_params
      params.fetch(:search_filter) { {} }.merge({
        nearby: current_student.address_details,
      })
    end
  end
end
