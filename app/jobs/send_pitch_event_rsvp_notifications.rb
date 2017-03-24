class SendPitchEventRSVPNotifications < ActiveJob::Base
  queue_as :default

  def perform(participant_id, event_ids = {})
    if event_ids[:ra_removed_participant_from]
      NotifyAmbassadorOfTeamLeftEventJob.perform_now(
        event_ids[:ra_removed_participant_from],
        participant_id,
        ra_removed: true
      )

      NotifyTeamMembersOfLeftEventJob.perform_now(
        event_ids[:ra_removed_participant_from],
        participant_id,
        ra_removed: true
      )
    end

    if event_ids[:ra_removed_judge_from]
      NotifyAmbassadorOfJudgeLeftEventJob.perform_now(
        event_ids[:ra_removed_judge_from],
        participant_id,
        ra_removed: true
      )

      NotifyJudgeOfLeftEventJob.perform_now(
        event_ids[:ra_removed_judge_from],
        participant_id,
        ra_removed: true
      )
    end

    if event_ids[:ra_added_participant_to]
      NotifyAmbassadorOfTeamJoinedEventJob.perform_now(
        event_ids[:ra_added_participant_to],
        participant_id,
        ra_added: true
      )

      NotifyTeamMembersOfJoinedEventJob.perform_now(
        event_ids[:ra_added_participant_to],
        participant_id,
        ra_added: true
      )
    end

    if event_ids[:ra_added_judge_to]
      NotifyAmbassadorOfJudgeJoinedEventJob.perform_now(
        event_ids[:ra_added_judge_to],
        participant_id,
        ra_added: true
      )

      NotifyJudgeOfJoinedEventJob.perform_now(
        event_ids[:ra_added_judge_to],
        participant_id,
        ra_added: true
      )
    end

    if event_ids[:leaving_event_id]
      NotifyAmbassadorOfTeamLeftEventJob.perform_now(
        event_ids[:leaving_event_id],
        participant_id
      )

      NotifyTeamMembersOfLeftEventJob.perform_now(
        event_ids[:leaving_event_id],
        participant_id
      )
    end

    if event_ids[:joining_event_id]
      NotifyAmbassadorOfTeamJoinedEventJob.perform_now(
        event_ids[:joining_event_id],
        participant_id
      )

      NotifyTeamMembersOfJoinedEventJob.perform_now(
        event_ids[:joining_event_id],
        participant_id
      )
    end

    if event_ids[:judge_leaving_event_id]
      NotifyAmbassadorOfJudgeLeftEventJob.perform_now(
        event_ids[:judge_leaving_event_id],
        participant_id
      )

      NotifyJudgeOfLeftEventJob.perform_now(
        event_ids[:judge_leaving_event_id],
        participant_id
      )
    end

    if event_ids[:judge_joining_event_id]
      NotifyAmbassadorOfJudgeJoinedEventJob.perform_now(
        event_ids[:judge_joining_event_id],
        participant_id
      )

      NotifyJudgeOfJoinedEventJob.perform_now(
        event_ids[:judge_joining_event_id],
        participant_id
      )
    end
  end
end
