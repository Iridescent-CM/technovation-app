class NotifyTeamMembersOfJoinedEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, team_id, options = {})
    event = RegionalPitchEvent.find(event_id)
    team = Team.find(team_id)

    return unless event.live?

    team.members.each do |member|
      if options[:ra_added]
        TeamMailer.notify_added_event(team, member, event).deliver_now
      else
        TeamMailer.confirm_joined_event(team, member, event).deliver_now
      end
    end
  end
end
