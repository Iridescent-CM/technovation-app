module Student
  class MentorSearchesController < StudentController
    include ::MentorSearchesController

    private
    def user
      current_student
    end
  end
end
