module ClubAmbassador
  class ClubLocationsController < ClubAmbassadorController
    include LocationController

    layout "club_ambassador"

    private

    def db_record
      @db_record ||= if params.has_key?(:club_id)
        Club.find(params.fetch(:club_id))
      end
    end
  end
end
