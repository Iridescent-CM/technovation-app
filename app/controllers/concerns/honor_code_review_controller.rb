module HonorCodeReviewController
  extend ActiveSupport::Concern

  def show
    @team_submission = current_team.submission

    if current_profile.rebranded?
      render "honor_codes/rebranded/review"
    else
      render "honor_codes/review"
    end
  end
end
