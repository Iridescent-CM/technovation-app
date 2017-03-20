class NotifyTeamMembersOfLeftEventJob < ActiveJob::base
  queue_as :default

  def perform(event_id, team_id)
    event = RegionalPitchEvent.find(event_id)
    team = Team.find(team_id)

    team.members.each do |member|
      TeamMailer.confirm_left_event(team, member, event).deliver_now
    end
  end
end
