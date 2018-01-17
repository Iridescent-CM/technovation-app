module Mentor
  class TeamSubmissionPublicationsController < MentorController
    def create
      submission = TeamSubmission
        .joins(team: :mentors)
        .where("mentor_profiles.id = ?", current_mentor.id)
        .friendly
        .find(params[:id])

      submission.publish!

      redirect_to mentor_published_team_submission_path(submission),
       success: "Your submission has been entered for judging!"
    end
  end
end
