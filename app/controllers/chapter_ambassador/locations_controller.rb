module ChapterAmbassador
  class LocationsController < ChapterAmbassadorController
    include LocationController

    skip_before_action :require_chapterable_and_ambassador_onboarded
  end
end
