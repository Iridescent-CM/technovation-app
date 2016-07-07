class StudentController < ApplicationController
  include Authenticated

  layout 'student'

  helper_method :current_student

  private
  def current_student
    StudentAccount.find_with_token(cookies.fetch(:auth_token) { "" })
  end
end
