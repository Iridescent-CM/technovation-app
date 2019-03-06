class AddTeamToRegionalEvent
  def self.call(event, team)
    if event.divisions.exclude?(team.division)
      raise IncompatibleDivisionError,
        "This team is not in the correct division for this event"
    end

    if event.at_team_capacity?
      raise EventAtTeamCapacityError,
        "This team cannot attend the event as it is currently full"
    end

    InvalidateExistingJudgeData.(team)

    event.teams << team

    SendPitchEventRSVPNotifications.perform_later(
      team.id,
      joining_event_id: event.id
    )
  end

  class RemoveIncompatibleDivisionTeams
    def self.call(event)
      incompatible_teams = event.teams.includes(
        :regional_pitch_events,
        :division,
        team_submissions: :submission_scores,
      ).where.not("divisions.id" => event.division_ids)

      incompatible_teams.each { |t| InvalidateExistingJudgeData.(t) }

      incompatible_teams
    end
  end

  class IncompatibleDivisionError < StandardError; end
  class EventAtTeamCapacityError < StandardError; end
end
