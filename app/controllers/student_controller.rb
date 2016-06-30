class StudentController < ApplicationController
  before_filter :authenticate_student!

  helper_method :current_student

  private
  def authenticate_student!
    FindAuthenticationRole.authenticate(:student, cookies, failure: -> {
      save_redirected_path && go_to_signin("student")
    })
  end

  def current_student
    @current_student ||= FindAuthenticationRole.current(:student, cookies)
  end

  def profile_type
    "student"
  end
end
