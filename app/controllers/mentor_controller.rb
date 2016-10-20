class MentorController < ApplicationController
  include Authenticated

  helper_method :current_mentor

  before_action -> {
    unless current_mentor.honor_code_signed?
      save_redirected_path
      redirect_to mentor_interruptions_path(issue: :honor_code)
    end
  }, unless: -> {
    %w{interruptions accounts honor_code_agreements dashboards}.include?(controller_name)
  }

  private
  def current_mentor
    @current_mentor ||= MentorAccount.find_with_token(cookies.fetch(:auth_token) { "" })
  end
end
