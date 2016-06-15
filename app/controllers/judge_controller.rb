class JudgeController < ApplicationController
  before_filter :authenticate_judge!

  private
  def authenticate_judge!
    FindAuthenticationRole.authenticate(:judge, cookies, failure: -> {
      save_redirected_path && go_to_signin
    })
  end

  def current_judge
    @current_judge ||= FindAuthenticationRole.current(:judge, cookies)
  end
end
