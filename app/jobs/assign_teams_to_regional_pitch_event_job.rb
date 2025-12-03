class AssignTeamsToRegionalPitchEventJob < ActiveJob::Base
  queue_as :default

  def perform(regional_pitch_event_id:, team_ids:)
    regional_pitch_event = RegionalPitchEvent.find(regional_pitch_event_id)

    DataProcessors::AssignTeamsToRegionalPitchEvent.new(regional_pitch_event:, team_ids:).call
  end
end
