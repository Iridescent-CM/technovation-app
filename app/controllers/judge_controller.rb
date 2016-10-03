class JudgeController < ApplicationController
  include Authenticated

  helper_method :current_judge

  private
  def current_judge
    @current_judge ||= FindAccount.current(:judge, cookies)
  end
end
