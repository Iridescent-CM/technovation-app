module RegionalAmbassador
  class LocationDetailsController < RegionalAmbassadorController
    helper_method :current_profile

    def show
      if !current_ambassador.address_details.blank?
        redirect_to regional_ambassador_profile_path(
          anchor: '!location'
        ) and return
      end

      render template: "location_details/show"
    end

    private
    def current_profile
      current_ambassador
    end
  end
end
