class StudentController < ApplicationController
  include Authenticated

  layout 'student'

  private
  def current_student
    StudentAccount.find_with_token(cookies.fetch(:auth_token) { "" })
  end
end
