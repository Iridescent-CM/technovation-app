class StudentController < ApplicationController
  include Authenticated

  helper_method :current_student, :current_team

  before_action -> {
    unless current_student.valid?
      redirect_to student_interruptions_path(issue: :invalid_profile)
    end

    unless current_student.honor_code_signed?
      save_redirected_path
      redirect_to student_interruptions_path(issue: :honor_code)
    end
  }, unless: -> {
    %w{interruptions accounts honor_code_agreements dashboards}.include?(controller_name)
  }

  private
  def current_student
    @current_student ||= StudentAccount.find_with_token(cookies.fetch(:auth_token) { "" })
  end

  def current_team
    current_student.team
  end
end
