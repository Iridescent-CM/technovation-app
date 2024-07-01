module ChapterAmbassador
  class LocationsController < ChapterAmbassadorController
    include LocationController

    skip_before_action :require_chapter_and_chapter_ambassador_onboarded
  end
end
