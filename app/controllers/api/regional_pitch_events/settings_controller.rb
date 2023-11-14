module Api::RegionalPitchEvents
  class SettingsController < ActionController::API
    def index
      render json: {
        canCreateEvents: SeasonToggles.create_regional_pitch_event?,
        canAddTeamsToEvents: SeasonToggles.add_teams_to_regional_pitch_event?
      }
    end
  end
end
