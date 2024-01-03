class TeamUpdating
  private

  attr_reader :team, :updater

  public

  def initialize(team, updater)
    @team = team
    @updater = updater
  end

  def self.execute(team, attrs, updater = nil)
    new(team, updater).update(attrs)
  end

  def update(attrs)
    if team.update(attrs)
      perform_callbacks
      true
    else
      false
    end
  end

  def perform_callbacks
    Geocoding.perform(team)

    if updater.present? && !updater.valid_coordinates?
      updater.latitude = team.latitude
      updater.longitude = team.longitude
      Geocoding.perform(updater).with_save
    end

    Casting.delegating(team => RegionalPitchEventAttendee) do
      team.preserve_pitch_event_region
    end

    Casting.delegating(team => DivisionChooser) do
      team.reconsider_division
    end

    team.save
    team.create_activity(
      key: "team.update"
    )
  end

  module RegionalPitchEventAttendee
    def preserve_pitch_event_region
      if us_state_changed? or saved_change_to_country?
        regional_pitch_events.destroy_all
      end
    end

    private

    def us_state_changed?
      country_code == "US" and saved_change_to_state_province?
    end
  end
end
