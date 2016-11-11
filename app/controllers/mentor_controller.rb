class MentorController < ApplicationController
  include Authenticated

  layout "mentor"
  helper_method :current_mentor

  before_action -> {
    unless current_mentor.honor_code_signed?
      save_redirected_path
      redirect_to interruptions_path(issue: :honor_code)
    end
  }, unless: -> {
    %w{interruptions profiles honor_code_agreements dashboards background_checks}.include?(controller_name)
  }

  private
  def current_mentor
    @current_mentor ||= MentorProfile.joins(:account)
      .find_by("accounts.auth_token = ?", cookies.fetch(:auth_token) { "" }) ||
    Account::NoAuthFound.new
  end

  def model_name
    "mentor"
  end
end
