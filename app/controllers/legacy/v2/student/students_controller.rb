module Legacy
  module V2
    module Student
      class StudentsController < StudentController
        def show
          @student = StudentProfile.find(params.fetch(:id))
        end
      end
    end
  end
end
