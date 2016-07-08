class MentorController < ApplicationController
  include Authenticated

  helper_method :current_mentor

  private
  def current_mentor
    @current_mentor ||= MentorAccount.find_with_token(cookies.fetch(:auth_token) { "" })
  end
end
