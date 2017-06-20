module Student
  class RegionalPitchEventsController < StudentController
    before_action :require_current_team

    def show
      if params[:id] == "virtual"
        @regional_pitch_event = VirtualRegionalPitchEvent.new
        render template: 'regional_pitch_events/virtual'
      else
        @regional_pitch_event = RegionalPitchEvent.find(params[:id])
        render template: 'regional_pitch_events/show'
      end
    end
  end
end
