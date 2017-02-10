module Judge
  class LocationDetailsController < JudgeController
    helper_method :current_profile

    def show
      render template: "location_details/show"
    end

    private
    def current_profile
      current_judge
    end
  end
end
