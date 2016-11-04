class JudgeController < ApplicationController
  include Authenticated

  layout "judge"
  helper_method :current_judge

  private
  def current_judge
    @current_judge ||= JudgeProfile.joins(:account)
      .where("accounts.auth_token = ?", cookies.fetch(:auth_token))
      .first or Account::NoAuthFound.new
  end
end
