module ClubAmbassador
  class ClubLocationsController < AmbassadorController
    include LocationController

    skip_before_action :require_chapterable_and_ambassador_onboarded

    layout "club_ambassador_rebrand"

    private

    def db_record
      @db_record ||= if params.has_key?(:club_id)
        Club.find(params.fetch(:club_id))
      end
    end
  end
end
