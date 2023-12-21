module TeamSubmissionVideoLinkReviewController
  extend ActiveSupport::Concern

  def update
    submission = current_profile.team_submissions.current.friendly.find(video_link_params[:id])

    if submission.update({video_link_params[:piece] => video_link_params[:value]})
      submission.team.create_activity(
        trackable: current_profile.account,
        key: "submission.update",
        parameters: {piece: video_link_params[:piece]},
        recipient: submission
      )
      msg = {success: "You saved your #{params[:piece].humanize}!"}
    else
      msg = if submission.errors.full_messages
        {alert: submission.errors.full_messages.join(" , ")}
      else
        {alert: "An error has occurred. Please try again later."}
      end
    end

    redirect_to send("#{current_scope}_team_submission_section_path", id: submission.to_param, section: :pitch), msg
  end

  private

  def video_link_params
    params.permit(:piece, :value, :id)
  end
end
