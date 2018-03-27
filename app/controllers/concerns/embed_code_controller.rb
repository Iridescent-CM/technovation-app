module EmbedCodeController
  extend ActiveSupport::Concern

  def show
    @team_submission = TeamSubmission.friendly.find(params[:id])
    render inline: @team_submission.embed_code(params.fetch(:piece))
  end
end
