class NotifyAmbassadorOfTeamLeftEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, team_id, options = {})
    event = RegionalPitchEvent.find(event_id)

    return unless event.live?

    team = Team.find(team_id)

    if options[:ra_removed]
      AmbassadorMailer.confirm_team_removed(
        event.regional_ambassador_profile.account,
        event,
        team
      ).deliver_now
    else
      AmbassadorMailer.team_left_event(
        event.regional_ambassador_profile.account,
        event,
        team
      ).deliver_now
    end
  end
end
