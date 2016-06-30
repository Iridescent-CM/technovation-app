module Student
  module Mentors
    class SearchesController < StudentController
      def show
        @search_filter = SearchFilter.new(params.fetch(:search_filter) { {} })
        @expertises = Expertise.all
        @mentors = SearchMentors.(@search_filter)
      end
    end
  end
end
