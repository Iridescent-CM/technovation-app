module Mentor
  class RegionalPitchEventsController < MentorController
    def show
      if params[:id] == "virtual"
        @regional_pitch_event = Team::VirtualRegionalPitchEvent.new
        render template: 'regional_pitch_events/virtual'
      else
        @regional_pitch_event = RegionalPitchEvent.find(params[:id])
        render template: 'regional_pitch_events/show'
      end
    end
  end
end
