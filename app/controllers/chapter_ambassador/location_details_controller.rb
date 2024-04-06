module ChapterAmbassador
  class LocationDetailsController < ChapterAmbassadorController
    helper_method :current_profile

    layout "chapter_ambassador_rebrand"

    private

    def current_profile
      current_ambassador
    end
  end
end
