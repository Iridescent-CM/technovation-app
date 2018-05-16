module Admin
  class ContestRankChangesController < AdminController
    def create
      submission = TeamSubmission.find(contest_rank_params.fetch(:id))
      rank = contest_rank_params.fetch(:contest_rank)

      submission.public_send("#{rank}!")

      render json: { flash: { success: "#{submission.team_name} has been marked as a #{rank}!"} }
    end

    private
    def contest_rank_params
      params.require(:team_submission).permit(:id, :contest_rank)
    end
  end
end