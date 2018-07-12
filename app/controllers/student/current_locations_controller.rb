module Student
  class CurrentLocationsController < StudentController
    def show
      render json: {
        city: current_account.city,
        state_code: current_account.state_province,
        country_code: current_account.country,
      }
    end
  end
end