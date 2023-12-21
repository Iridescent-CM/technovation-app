module Student
  class LocationsController < StudentController
    include LocationController

    private

    def db_record
      @db_record ||= if params.fetch(:team_id) { false }
        current_team
      else
        current_account
      end
    end
  end
end
