class MentorController < ApplicationController
  before_action :create_judge_mentor_on_dashboard
  include Authenticated

  layout "mentor"
  helper_method :current_mentor

  before_action -> {
    if "mentor" != cookies[:last_profile_used]
      cookies[:last_profile_used] = "mentor"
    end
  }

  before_action -> {
    unless current_mentor.honor_code_signed?
      save_redirected_path
      redirect_to interruptions_path(issue: :honor_code)
    end
  }, unless: -> {
    %w{interruptions profiles honor_code_agreements cookies dashboards background_checks}.include?(controller_name)
  }

  private
  def current_mentor
    @current_mentor ||= current_account.mentor_profile
  end

  def model_name
    "mentor"
  end

  def create_judge_mentor_on_dashboard
  end
end
