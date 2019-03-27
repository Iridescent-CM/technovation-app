require 'fill_pdfs'

module Student
  class DashboardsController < StudentController
    include LocationStorageController

    def show
      @regional_events = available_regional_events
    end

    private
    def available_regional_events
      if SeasonToggles.select_regional_pitch_event?
        RegionalPitchEvent.available_to(
          current_team.submission
        )
      else
        RegionalPitchEvent.none
      end
    end
  end
end
