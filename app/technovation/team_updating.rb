class TeamUpdating
  private
  attr_reader :team

  public
  def initialize(team)
    @team = team
  end

  def self.execute(team, attrs)
    new(team).update(attrs)
  end

  def update(attrs)
    if team.update_attributes(attrs)
      perform_callbacks
      true
    else
      false
    end
  end

  def perform_callbacks
    Geocoding.perform(team).with_save
  end
end
