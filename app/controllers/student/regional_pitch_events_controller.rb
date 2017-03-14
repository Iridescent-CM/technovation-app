module Student
  class RegionalPitchEventsController < StudentController
    def show
      if params[:id] == "virtual"
        @regional_pitch_event = Team::VirtualRegionalPitchEvent.new
        render template: 'regional_pitch_events/virtual'
      else
        @regional_pitch_event = RegionalPitchEvent.find(params[:id])
      end
    end
  end
end
