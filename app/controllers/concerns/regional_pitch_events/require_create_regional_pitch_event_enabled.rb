module RegionalPitchEvents::RequireCreateRegionalPitchEventEnabled
  extend ActiveSupport::Concern

  included do
    before_action :require_create_regional_pitch_event_enabled, only: [:new, :create]
  end

  private

  def require_create_regional_pitch_event_enabled
    unless SeasonToggles.create_regional_pitch_event?
      redirect_to chapter_ambassador_events_list_path,
        alert: "New events cannot be create at this time."
    end
  end
end
