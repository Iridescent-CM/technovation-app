module Legacy
  module V2
    module Student
      class DashboardsController < StudentController

        def show
          @regional_events = RegionalPitchEvent.available_to(current_team.submission)
        end
      end
    end
  end
end
