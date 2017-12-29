module Mentor
  class ScreenshotsController < MentorController
    include ScreenshotController

    def current_team
      id = params&.dig(:team_submission, :id) ||
        raise(KeyError, "missing key for team_submission[id]")

      @current_team ||= current_mentor.teams
        .joins(:submission)
        .where("team_submissions.id = ?", id)
        .first ||
          raise(
            ActiveRecord::RecordNotFound,
            "team not found with id: #{id}"
          )
    end
  end
end
