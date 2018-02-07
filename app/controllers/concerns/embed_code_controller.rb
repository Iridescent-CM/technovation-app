module EmbedCodeController
  extend ActiveSupport::Concern

  def show
    @team_submission = current_team.submission
    render inline: @team_submission.embed_code(params.fetch(:piece))
  end
end
