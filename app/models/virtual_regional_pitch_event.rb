class VirtualRegionalPitchEvent
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :id

  def self.model_name
    ActiveModel::Name.new(self, nil, "RegionalPitchEvent")
  end

  def persisted?
    true
  end

  def name; "Virtual (online) Judging"; end
  def name_with_friendly_country_prefix; name; end
  def live?; false; end
  def virtual?; true; end
  def unofficial?; false; end
  def id; "virtual"; end
  def city; "No city, all online"; end
  def venue_address; "No address, all online"; end
  def eventbrite_link; end

  def teams
    Team.not_attending_live_event
  end

  def team_submissions
    TeamSubmission.includes(team: :regional_pitch_events)
                  .references(:regional_pitch_events)
                  .where("regional_pitch_events.id IS NULL")
  end

  def timezone
    "US/Pacific"
  end

  def starts_at
    DateTime.new(2017, 5, 1, 7, 0, 0).in_time_zone(timezone)
  end

  def ends_at
    DateTime.new(2017, 5, 16, 6, 59, 59).in_time_zone(timezone)
  end

  def divisions
    [Division.junior, Division.senior]
  end
end
