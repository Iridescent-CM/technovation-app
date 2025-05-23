module ChapterAmbassador
  class LocationDetailsController < ChapterAmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded
    helper_method :current_profile

    layout "chapter_ambassador_rebrand"

    def show
      render template: "location_details/show"
    end

    private

    def current_profile
      current_ambassador
    end
  end
end
