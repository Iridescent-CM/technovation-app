module Student
  class MentorSearchesController < StudentController
    def new
      params[:nearby] = current_student.address_details if params[:nearby].blank?
      @search_filter = SearchFilter.new(search_filter_params)
      @expertises = Expertise.all
      @mentors = SearchMentors.(@search_filter).paginate(page: params[:page])
    end

    private
    def search_filter_params
      params.fetch(:search_filter) { {} }.merge({
        nearby: params.fetch(:nearby),
        user: current_student,
      })
    end
  end
end
