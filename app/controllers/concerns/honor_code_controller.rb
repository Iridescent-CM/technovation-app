module HonorCodeController
  extend ActiveSupport::Concern

  def show
    if current_team.submission.present?
      redirect_to [
        current_scope,
        current_team.submission,
        piece: :honor_code,
      ]
    else
      redirect_to [:new, current_scope, :team_submission]
    end
  end
end
