module Student
  module Mentors
    class SearchesController < StudentController
      def show
        @mentors = Mentor.all
      end
    end
  end
end
