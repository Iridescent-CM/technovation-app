class SendPitchEventRSVPNotifications < ActiveJob::Base
  queue_as :default

  def perform(team_id, event_ids = {})
    if event_ids[:ra_removed_participant_from]
      NotifyAmbassadorOfTeamLeftEventJob.perform_now(
        event_ids[:ra_removed_participant_from],
        team_id,
        ra_removed: true
      )

      NotifyTeamMembersOfLeftEventJob.perform_now(
        event_ids[:ra_removed_participant_from],
        team_id,
        ra_removed: true
      )
    end

    if event_ids[:leaving_event_id]
      NotifyAmbassadorOfTeamLeftEventJob.perform_now(
        event_ids[:leaving_event_id],
        team_id
      )

      NotifyTeamMembersOfLeftEventJob.perform_now(
        event_ids[:leaving_event_id],
        team_id
      )
    end

    if event_ids[:joining_event_id]
      NotifyAmbassadorOfTeamJoinedEventJob.perform_now(
        event_ids[:joining_event_id],
        team_id
      )

      NotifyTeamMembersOfJoinedEventJob.perform_now(
        event_ids[:joining_event_id],
        team_id
      )
    end
  end
end
