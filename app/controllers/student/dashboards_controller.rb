require 'fill_pdfs'

module Student
  class DashboardsController < StudentController
    def show
      @regional_events = available_regional_events

      if SeasonToggles.display_scores?
        FillPdfs.(CertificateRecipient.new(current_student), :completion)
      end
    end

    private
    def available_regional_events
      if SeasonToggles.select_regional_pitch_event?
        RegionalPitchEvent.available_to(current_team.submission)
      else
        RegionalPitchEvent.none
      end
    end
  end
end
