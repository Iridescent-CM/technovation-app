module ClubAmbassador
  class ResourcesController < AmbassadorController
    skip_before_action :require_chapterable_and_ambassador_onboarded

    def show
    end
  end
end
