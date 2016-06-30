module Student
  module Mentors
    class SearchesController < StudentController
      def show
        @search_filter = SearchFilter.new(params.fetch(:search_filter) { {} })
        @expertises = Expertise.all
        @mentors = SearchMentors.(@search_filter).paginate(page: params[:page])
      end
    end
  end
end
