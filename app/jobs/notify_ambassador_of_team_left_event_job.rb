class NotifyAmbassadorOfTeamLeftEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, team_id, options = {})
    event = RegionalPitchEvent.find(event_id)

    return unless event.live?

    team = Team.find(team_id)

    if options[:chapter_ambassador_removed]
      AmbassadorMailer.confirm_team_removed(
        event.ambassador.account,
        event,
        team
      ).deliver_now
    else
      AmbassadorMailer.team_left_event(
        event.ambassador.account,
        event,
        team
      ).deliver_now
    end
  end
end
