module Student
  class StudentsController < StudentController
    def show
      @student = StudentAccount.find(params.fetch(:id))
    end
  end
end
