class NotifyTeamMembersOfLeftEventJob < ActiveJob::Base
  queue_as :default

  def perform(event_id, team_id, options = {})
    event = RegionalPitchEvent.find(event_id)

    return unless event.live?

    team = Team.find(team_id)

    team.members.each do |member|
      if options[:chapter_ambassador_removed]
        TeamMailer.notify_removed_event(team, member, event).deliver_now
      else
        TeamMailer.confirm_left_event(team, member, event).deliver_now
      end
    end
  end
end
