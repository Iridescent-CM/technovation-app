module ClubAmbassador
  class DashboardsController < AmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout "club_ambassador_rebrand"

    def show
    end
  end
end
