module Mentor
  class TeamSubmissionPublicationsController < MentorController
    def create
      submission = TeamSubmission
        .joins(team: :mentors)
        .where("mentor_profiles.id = ?", current_mentor.id)
        .friendly
        .find(params[:id])

      submission.publish!

      redirect_to send("#{current_scope}_published_submission_confirmation_path", team_id: submission.team_id),
        success: "Your submission has been entered for judging!"
    end
  end
end
