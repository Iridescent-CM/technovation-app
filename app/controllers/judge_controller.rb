class JudgeController < ApplicationController
  before_filter :authenticate_judge!

  private
  def authenticate_judge!
    Authentication.authenticate_judge(cookies, failure: -> {
      save_redirected_path && go_to_signin
    })
  end

  def current_judge
    @current_judge ||= Authentication.current_judge(cookies)
  end
end
