class AdminController < ApplicationController
  include Authenticated

  layout 'admin'

  helper_method :current_admin

  before_action -> {
    cookies.permanent[:export_email] ||= ENV.fetch("ADMIN_EMAIL")
    params.permit!
  }

  def current_user
    current_admin.account
  end

  def current_scope
    "admin"
  end

  private
  def current_admin
    @current_admin ||= current_account.admin_profile
  end
end
