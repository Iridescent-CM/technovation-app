class JudgeController < ApplicationController
  include Authenticated

  layout "judge"
  helper_method :current_judge

  private
  def current_judge
    @current_judge ||= JudgeProfile.joins(:account)
      .find_by("accounts.auth_token = ?", cookies.fetch(:auth_token) { "" }) ||
    Account::NoAuthFound.new
  end

  def model_name
    "judge"
  end
end
