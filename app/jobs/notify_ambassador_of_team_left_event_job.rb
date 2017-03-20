class NotifyAmbassadorOfTeamLeftEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, team_id)
    event = RegionalPitchEvent.find(event_id)

    if event.live?
      team = Team.find(team_id)

      AmbassadorMailer.team_left_event(
        event.regional_ambassador_profile.account,
        event,
        team
      ).deliver_now
    end
  end
end
