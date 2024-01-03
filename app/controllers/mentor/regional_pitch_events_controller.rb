module Mentor
  class RegionalPitchEventsController < MentorController
    def index
      @regional_events = RegionalPitchEvent.available_to(
        current_team.submission
      )
      render template: "regional_pitch_events/index"
    end

    def show
      if params[:id] == "virtual"
        @regional_pitch_event = VirtualRegionalPitchEvent.new
        render template: "regional_pitch_events/virtual"
      else
        @regional_pitch_event = RegionalPitchEvent.find(params[:id])
        render template: "regional_pitch_events/show"
      end
    end
  end
end
