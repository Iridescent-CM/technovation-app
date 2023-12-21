module Judge
  class RegionalPitchEventsController < JudgeController
    def show
      @regional_pitch_event = RegionalPitchEvent.find(params[:id])
      render template: "regional_pitch_events/show"
    end
  end
end
