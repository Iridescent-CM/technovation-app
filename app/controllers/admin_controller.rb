class AdminController < ApplicationController
  include Authenticated

  layout 'admin'

  helper_method :current_admin

  before_action -> {
    cookies[:export_email] ||= "info@technovationchallenge.org"
  }

  private
  def current_admin
    @current_admin ||= AdminProfile.joins(:account).find_by("accounts.auth_token = ?", cookies.fetch(:auth_token) { "" })
  end
end
