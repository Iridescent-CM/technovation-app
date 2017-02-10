module Mentor
  class LocationDetailsController < MentorController
    helper_method :current_profile

    def show
      render template: "location_details/show"
    end

    private
    def current_profile
      current_mentor
    end
  end
end
