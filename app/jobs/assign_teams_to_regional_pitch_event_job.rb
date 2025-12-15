class AssignTeamsToRegionalPitchEventJob < ActiveJob::Base
  queue_as :default

  def perform(regional_pitch_event_id:, team_ids:, account_id:)
    regional_pitch_event = RegionalPitchEvent.find(regional_pitch_event_id)
    account = Account.find(account_id)
    assignment_result = DataProcessors::AssignTeamsToRegionalPitchEvent.new(regional_pitch_event:, team_ids:).call

    AmbassadorMailer.assigned_teams_to_event(
      event: regional_pitch_event,
      account:,
      assignment_result:
    ).deliver_now
  end
end
