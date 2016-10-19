class StudentController < ApplicationController
  include Authenticated

  helper_method :current_student, :current_team

  before_action -> {
    unless current_student.valid?
      redirect_to student_interruptions_path
    end
  }, unless: -> { %w{errors accounts}.include?(controller_name) }

  private
  def current_student
    @current_student ||= StudentAccount.find_with_token(cookies.fetch(:auth_token) { "" })
  end

  def current_team
    current_student.team
  end
end
