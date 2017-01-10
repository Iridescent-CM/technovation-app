class StudentController < ApplicationController
  include Authenticated

  layout "student"
  helper_method :current_student, :current_team

  before_action -> {
    unless current_student.honor_code_signed?
      save_redirected_path
      redirect_to interruptions_path(issue: :honor_code) and return
    end
  }, unless: -> {
    %w{interruptions cookies profiles honor_code_agreements dashboards parental_consent_notices}.include?(controller_name)
  }

  private
  def current_student
    @current_student ||= current_account.student_profile
  end

  def current_team
    current_student.team
  end

  def model_name
    "student"
  end
end
