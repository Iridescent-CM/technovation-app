module Mentor
  class RegionalPitchEventsTeamListsController < MentorController
    helper_method :events_available_to,
      :can_select_live_event?

    def show
      @current_teams = current_mentor.teams.current.order("teams.name")
    end

    private

    def events_available_to(submission)
      @events_available ||= {}

      @events_available[submission.id] ||=
        RegionalPitchEvent.available_to(submission)
    end

    def can_select_live_event?(team)
      SeasonToggles.select_regional_pitch_event? and
        !team.live_event? and
        events_available_to(team.submission).any?
    end
  end
end
