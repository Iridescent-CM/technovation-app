class AdminController < ApplicationController
  include Authenticated

  layout 'admin'

  helper_method :current_admin

  private
  def current_admin
    @current_admin ||= FindAccount.current(:admin, cookies)
  end
end
