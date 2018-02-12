module HonorCodeReviewController
  extend ActiveSupport::Concern

  def show
    @team_submission = current_team.submission
    render "honor_codes/review"
  end
end
