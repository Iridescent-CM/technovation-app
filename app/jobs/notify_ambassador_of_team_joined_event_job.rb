class NotifyAmbassadorOfTeamJoinedEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, team_id, options = {})
    event = RegionalPitchEvent.find(event_id)

    return unless event.live?

    team = Team.find(team_id)

    if options[:chapter_ambassador_added]
      AmbassadorMailer.confirm_team_added(
        event.ambassador.account,
        event,
        team
      ).deliver_now
    else
      AmbassadorMailer.team_joined_event(
        event.ambassador.account,
        event,
        team
      ).deliver_now
    end
  end
end
