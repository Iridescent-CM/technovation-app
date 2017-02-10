module RegionalAmbassador
  class LocationDetailsController < RegionalAmbassadorController
    helper_method :current_profile

    def show
      render template: "location_details/show"
    end

    private
    def current_profile
      current_ambassador
    end
  end
end
