module Student
  class TeamsController < StudentController
    include TeamController

    private
    def current_account
      current_student
    end
  end
end
