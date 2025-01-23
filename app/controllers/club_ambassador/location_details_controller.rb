module ClubAmbassador
  class LocationDetailsController < ClubAmbassadorController
    helper_method :current_profile

    layout "club_ambassador"

    def show
      render template: "location_details/show"
    end

    private

    def current_profile
      current_ambassador
    end
  end
end
