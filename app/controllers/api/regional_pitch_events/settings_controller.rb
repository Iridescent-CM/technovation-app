module Api::RegionalPitchEvents
  class SettingsController < ActionController::API
    def index
      render json: {
        canCreateEvents: SeasonToggles.create_regional_pitch_event?
      }
    end
  end
end
