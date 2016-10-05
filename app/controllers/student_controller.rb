class StudentController < ApplicationController
  include Authenticated

  helper_method :current_student, :current_team

  private
  def current_student
    @current_student ||= StudentAccount.find_with_token(cookies.fetch(:auth_token) { "" })
  end

  def current_team
    current_student.team
  end
end
