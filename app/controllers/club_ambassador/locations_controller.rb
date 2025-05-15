module ClubAmbassador
  class LocationsController < AmbassadorController
    include LocationController

    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout "club_ambassador_rebrand"
  end
end
