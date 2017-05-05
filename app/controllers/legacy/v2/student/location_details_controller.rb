module Student
  class LocationDetailsController < StudentController
    helper_method :current_profile

    def show
      render template: "location_details/show"
    end

    private
    def current_profile
      current_student
    end
  end
end
