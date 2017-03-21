class NotifyAmbassadorOfTeamJoinedEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, team_id, options = {})
    event = RegionalPitchEvent.find(event_id)

    return unless event.live?

    team = Team.find(team_id)

    if options[:ra_added]
      AmbassadorMailer.confirm_team_added(
        event.regional_ambassador_profile.account,
        event,
        team
      ).deliver_now
    else
      AmbassadorMailer.team_joined_event(
        event.regional_ambassador_profile.account,
        event,
        team
      ).deliver_now
    end
  end
end
