module RegionalPitchEvents::RequireAddTeamsToRegionalPitchEventEnabled
  extend ActiveSupport::Concern

  included do
    before_action :require_add_teams_to_regional_pitch_event_enabled, only: :create
  end

  private

  def require_add_teams_to_regional_pitch_event_enabled
    unless SeasonToggles.add_teams_to_regional_pitch_event?
      redirect_to chapter_ambassador_event_path(params[:event_id]),
        alert: "Teams and judges cannot be added to events at this time."
    end
  end
end
