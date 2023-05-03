module Judge
  class EmbedCodesController < JudgeController
    include EmbedCodeController

    after_action :update_clicked_video_tracking, only: :show

    private

    def update_clicked_video_tracking
      submission_score = current_judge.submission_scores.find_by(team_submission_id: @team_submission.id)

      case params[:piece]
      when "pitch"
        submission_score.update(clicked_pitch_video: true)
      when "demo"
        submission_score.update(clicked_demo_video: true)
      end
    end
  end
end
