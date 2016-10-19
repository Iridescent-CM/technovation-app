module Student
  class InterruptionsController < StudentController
    def index
      render template: "student/interruptions/#{params[:issue]}_interruption"
    end
  end
end
