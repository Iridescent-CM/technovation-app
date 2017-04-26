module Student
  class TechnicalChecklistsController < StudentController
    def edit
      redirect_to student_dashboard_path
    end

    def update
      redirect_to student_dashboard_path
    end
  end
end
